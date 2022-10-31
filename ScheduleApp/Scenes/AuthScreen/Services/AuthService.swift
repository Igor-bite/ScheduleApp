//
//  AuthService.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 24.10.2022.
//  Copyright © 2022 messeb.com. All rights reserved.
//

import Foundation
import KeychainAccess

protocol AuthServiceProtocol {
    var currentUser: UserModel? { get }

    func signIn(withUsername username: String, password: String) async throws -> UserModel
    func tryToRestoreLogin() async throws -> UserModel
    func signUp(user: CreateUserModel) async throws -> UserModel
    func logout()
}

final class AuthService: AuthServiceProtocol {
    static let shared = AuthService()

    private let keychain = Keychain(service: "com.ScheduleApp.AuthInfo").synchronizable(true)
    private let network = NetworkService.shared

    var currentUser: UserModel?

    private init() {}

    func signIn(withUsername username: String, password: String) async throws -> UserModel {
        save(username: username, password: password)
        var user = try await network.request(UserTarget.current).map(UserModel.self)
        let roles = try await network.request(RoleTarget.role(id: user.id)).map([RoleModel].self)
        user.roles = roles.map { $0.name }
        currentUser = user
        return user
    }

    func tryToRestoreLogin() async throws -> UserModel {
        if let username = keychain[Constants.Keychain.usernameKey],
           let password = keychain[Constants.Keychain.passwordKey]
        {
            return try await signIn(withUsername: username,
                                    password: password)
        } else {
            throw AuthError.noCredentials
        }
    }

    private func save(username: String, password: String) {
        removeFromKeychain()
        keychain[Constants.Keychain.usernameKey] = username
        keychain[Constants.Keychain.passwordKey] = password
    }

    private func removeFromKeychain() {
        do {
            try keychain.remove(Constants.Keychain.usernameKey)
            try keychain.remove(Constants.Keychain.passwordKey)
        } catch {
            print(error.localizedDescription)
        }
    }

    func signUp(user: CreateUserModel) async throws -> UserModel {
        var loggedUser = try await network.request(UserTarget.create(user)).map(UserModel.self)
        let roles = try await network.request(RoleTarget.role(id: loggedUser.id)).map([RoleModel].self)
        loggedUser.roles = roles.map { $0.name }
        currentUser = loggedUser
        save(username: user.username, password: user.password)
        return loggedUser
    }

    func logout() {
        removeFromKeychain()
        currentUser = nil
        NotificationCenter.default.post(.init(name: .WantToLogOut))
    }

    func basicAuthHeader() -> String? {
        guard let username = keychain[Constants.Keychain.usernameKey],
              let password = keychain[Constants.Keychain.passwordKey],
              let data = (username + ":" + password).data(using: .utf8)
        else {
            return nil
        }
        return "Basic \(data.base64EncodedString())"
    }
}

enum AuthError: Error {
    case noCredentials
}
