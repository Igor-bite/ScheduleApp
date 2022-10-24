//
//  RegistrationScreenInteractor.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 24.10.2022.
//

import Foundation

final class RegistrationScreenInteractor {
    private let authService: AuthServiceProtocol

    init(authService: AuthServiceProtocol = AuthService.shared) {
        self.authService = authService
    }
}

// MARK: - Extensions -

extension RegistrationScreenInteractor: RegistrationScreenInteractorInterface {
    func login() async throws -> UserModel {
        try await authService.signIn(withUsername: "SomeUsername", password: "SomePassword")
    }
}
