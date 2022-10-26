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
        let user = try await network.request(UserTarget.current).map(UserModel.self)
        currentUser = user
        save(username: username, password: password)
        return user
    }

    func tryToRestoreLogin() async throws -> UserModel {
        try await signIn(withUsername: keychain[Constants.Keychain.usernameKey] ?? "",
                         password: keychain[Constants.Keychain.passwordKey] ?? "")
    }

    private func save(username: String, password: String) {
        keychain[Constants.Keychain.usernameKey] = username
        keychain[Constants.Keychain.passwordKey] = password
    }

    private func removeFromKeychain() {
        keychain[Constants.Keychain.usernameKey] = nil
        keychain[Constants.Keychain.passwordKey] = nil
    }

    func signUp(user: CreateUserModel) async throws -> UserModel {
        let loggedUser = try await network.request(UserTarget.create(user)).map(UserModel.self)
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
