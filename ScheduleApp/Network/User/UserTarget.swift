//
//  UserTarget.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 25.10.2022.
//  Copyright © 2022 messeb.com. All rights reserved.
//

import Foundation
import Moya

enum UserTarget {
    case current
    case update(UpdateUserModel)
    case create(CreateUserModel)
    case delete
    case user(id: Int)
    case all
}

extension UserTarget: TargetType {
    var path: String {
        switch self {
        case .all:
            return "/person/all"
        case .user(let id):
            return "/person/\(id)"
        default:
            return "/person"
        }
    }

    var method: Moya.Method {
        switch self {
        case .current, .user, .all:
            return .get
        case .update:
            return .put
        case .create:
            return .post
        case .delete:
            return .delete
        }
    }

    var task: Moya.Task {
        switch self {
        case .current, .user, .delete, .all:
            return .requestPlain
        case .update(let updateUserModel):
            return .requestJSONEncodable(updateUserModel)
        case .create(let createUserModel):
            return .requestJSONEncodable(createUserModel)
        }
    }
}
