//
//  PasswordChangeScreenInteractor.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 01.11.2022.
//

import Foundation

final class PasswordChangeScreenInteractor {
    private let profileService = ProfileService()
}

// MARK: - Extensions -

extension PasswordChangeScreenInteractor: PasswordChangeScreenInteractorInterface {
    func update(user: UpdateUserModel) async throws -> UserModel {
        try await profileService.update(user: user)
    }
}
