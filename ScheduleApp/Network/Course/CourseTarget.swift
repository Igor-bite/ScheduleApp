//
//  CourseTarget.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 25.10.2022.
//  Copyright © 2022 messeb.com. All rights reserved.
//

import Foundation
import Moya

enum CourseTarget {
    case taught
    case enrolled
    case update(UpdateCourseModel)
    case create(CreateCourseModel)
    case delete(id: Int)
    case course(id: Int)
    case lessons(id: Int)
    case clone(id: Int)
    case enroll(id: Int)
    case leave(id: Int)
    case all
}

extension CourseTarget: TargetType {
    var path: String {
        switch self {
        case .course(id: let id), .delete(id: let id):
            return "/course/\(id)"
        case .lessons(id: let id):
            return "/course/\(id)/lesson"
        case .all:
            return "/course/all"
        case .clone(id: let id):
            return "/course/clone/\(id)"
        case .enroll(id: let id):
            return "/course/enroll/\(id)"
        case .leave(id: let id):
            return "/course/leave/\(id)"
        case .enrolled:
            return "/course/enrolled"
        default:
            return "/course"
        }
    }

    var method: Moya.Method {
        switch self {
        case .taught, .course, .lessons, .all, .enrolled:
            return .get
        case .update, .enroll, .leave:
            return .put
        case .create, .clone:
            return .post
        case .delete:
            return .delete
        }
    }

    var task: Moya.Task {
        switch self {
        case .taught, .course, .lessons, .all, .enrolled, .delete, .leave, .enroll, .clone:
            return .requestPlain
        case .update(let updateCourseModel):
            return .requestJSONEncodable(updateCourseModel)
        case .create(let createCourseModel):
            return .requestJSONEncodable(createCourseModel)
        }
    }
}
