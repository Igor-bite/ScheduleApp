//
//  UserModel.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 24.10.2022.
//  Copyright © 2022 messeb.com. All rights reserved.
//

import Foundation

struct UserModel: Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let secondName: String
    let birthday: Date
    var roles: [RoleModel.Role]? = [.standard]

    var isAdmin: Bool {
        roles?.contains(.admin) ?? false
    }
}

struct CreateUserModel: Codable {
    let username: String
    let password: String
    let firstName: String
    let lastName: String
    let secondName: String
    let birthday: String

    init(username: String, password: String, firstName: String, lastName: String, secondName: String, birthday: Date) {
        self.username = username
        self.password = password
        self.firstName = firstName
        self.lastName = lastName
        self.secondName = secondName
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = .init(secondsFromGMT: 0)
        self.birthday = formatter.string(from: birthday)
    }
}

struct UpdateUserModel: Codable {
    let username: String
    let password: String
    let firstName: String
    let lastName: String
    let secondName: String
    let birthday: String
    let id: Int

    init(username: String, password: String,
         firstName: String, lastName: String,
         secondName: String, id: Int,
         birthday: Date)
    {
        self.username = username
        self.password = password
        self.firstName = firstName
        self.lastName = lastName
        self.secondName = secondName
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.birthday = formatter.string(from: birthday)
        self.id = id
    }
}
