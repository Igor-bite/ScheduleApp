//
//  ProfileScreenInteractor.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 31.10.2022.
//

import Foundation

final class ProfileScreenInteractor {
    private let profileService = ProfileService()
    private let authService = AuthService.shared
}

// MARK: - Extensions -

extension ProfileScreenInteractor: ProfileScreenInteractorInterface {
    func update(user: UpdateUserModel) async throws -> UserModel {
        try await profileService.update(user: user)
    }

    func removeAccount(user: UserModel?) async throws {
        try await profileService.removeAccount(user: user)
    }

    func logout() {
        authService.logout()
    }

    func createNewUser(user: CreateUserModel) async throws -> UserModel {
        try await profileService.createNewUser(user: user)
    }
}
