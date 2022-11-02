//
//  UserCreatorScreenInteractor.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 01.11.2022.
//

import Foundation

final class UserCreatorScreenInteractor {
    private let profileService = ProfileService()
}

// MARK: - Extensions -

extension UserCreatorScreenInteractor: UserCreatorScreenInteractorInterface {
    func create(user: CreateUserModel) async throws {
        _ = try await profileService.createNewUser(user: user)
    }
}
