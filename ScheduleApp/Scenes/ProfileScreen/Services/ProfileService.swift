//
//  ProfileService.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 01.11.2022.
//  Copyright © 2022 messeb.com. All rights reserved.
//

import Foundation

class ProfileService {
    private let network = NetworkService.shared

    func update(user: UpdateUserModel) async throws -> UserModel {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = .init(secondsFromGMT: 0)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
        return try await network.request(UserTarget.update(user)).map(UserModel.self, using: decoder)
    }

    func removeAccount(user: UserModel?) async throws {
        if let user = user {
            _ = try await network.request(UserTarget.delete(id: user.id))
        } else {
            _ = try await network.request(UserTarget.selfDelete)
        }
    }

    func createNewUser(user: CreateUserModel) async throws -> UserModel {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = .init(secondsFromGMT: 0)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
        return try await network.request(UserTarget.create(user)).map(UserModel.self, using: decoder)
    }
}
