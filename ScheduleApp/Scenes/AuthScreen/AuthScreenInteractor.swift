//
//  AuthScreenInteractor.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 24.10.2022.
//

import Foundation

final class AuthScreenInteractor {
    private let authService: AuthServiceProtocol

    init(authService: AuthServiceProtocol = AuthService.shared) {
        self.authService = authService
    }
}

// MARK: - Extensions -

extension AuthScreenInteractor: AuthScreenInteractorInterface {
    func signIn(withUsername username: String, password: String) async throws -> UserModel {
        try await authService.signIn(withUsername: username, password: password)
    }

    func signUp(_ user: CreateUserModel) async throws -> UserModel {
        try await authService.signUp(user: user)
    }
}
