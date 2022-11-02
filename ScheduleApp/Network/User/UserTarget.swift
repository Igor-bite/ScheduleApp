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
    case selfDelete
    case delete(id: Int)
    case user(id: Int)
    case all
}

extension UserTarget: TargetType {
    var path: String {
        switch self {
        case .all:
            return "/person/all"
        case .user(let id), .delete(let id):
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
        case .selfDelete, .delete:
            return .delete
        }
    }

    var task: Moya.Task {
        switch self {
        case .current, .user, .selfDelete, .delete, .all:
            return .requestPlain
        case .update(let updateUserModel):
            return .requestJSONEncodable(updateUserModel)
        case .create(let createUserModel):
            return .requestJSONEncodable(createUserModel)
        }
    }

    var headers: [String: String]? {
        switch self {
        case .create:
            return nil
        default:
            if let authHeader = AuthService.shared.basicAuthHeader() {
                return ["Authorization": authHeader]
            }
            return nil
        }
    }
}
