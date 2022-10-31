//
//  RoleTarget.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 31.10.2022.
//  Copyright © 2022 messeb.com. All rights reserved.
//

import Foundation
import Moya

enum RoleTarget {
    case role(id: Int)
}

extension RoleTarget: TargetType {
    var path: String {
        switch self {
        case .role(let id):
            return "/role/\(id)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .role:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        case .role:
            return .requestPlain
        }
    }
}
