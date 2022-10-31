//
//  LessonTarget.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 25.10.2022.
//  Copyright © 2022 messeb.com. All rights reserved.
//

import Foundation
import Moya

enum LessonTarget {
    case taught
    case update(UpdateLessonModel)
    case create(CreateLessonModel)
    case lesson(id: Int)
    case delete(id: Int)
    case enrolled
    case taughtBy(userId: Int)
    case all
}

extension LessonTarget: TargetType {
    var path: String {
        switch self {
        case .all:
            return "/lesson/all"
        case .enrolled:
            return "/lesson/enrolled"
        case .lesson(let id), .delete(let id):
            return "/lesson/\(id)"
        case .taughtBy(let id):
            return "/lesson/user/\(id)"
        default:
            return "/lesson"
        }
    }

    var method: Moya.Method {
        switch self {
        case .taught, .lesson, .all, .enrolled, .taughtBy:
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
        case .taught, .enrolled, .lesson, .delete, .taughtBy, .all:
            return .requestPlain
        case .update(let updateLessonModel):
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            return .requestCustomJSONEncodable(updateLessonModel, encoder: encoder)
        case .create(let createLessonModel):
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            return .requestCustomJSONEncodable(createLessonModel, encoder: encoder)
        }
    }
}
