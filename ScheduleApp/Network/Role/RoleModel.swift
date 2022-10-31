//
//  RoleModel.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 31.10.2022.
//  Copyright © 2022 messeb.com. All rights reserved.
//

import Foundation

struct RoleModel: Codable {
    enum Role: String, Codable {
        case admin = "ROLE_ADMIN"
        case standard = "ROLE_DEFAULT"
    }

    let id: Int
    let name: Role
}
