//
//  LessonModel.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 15.09.2022.
//

import UIKit

public struct LessonModel: Codable, Equatable {
    let id: Int
    let title: String
    let description: String
    let teacherId: Int
    let teacher: TeacherModel
    let courseId: Int
    let startDateTime: Date
    let endDateTime: Date
    let lessonType: LessonType
}

public struct TeacherModel: Codable, Equatable {
    let firstName: String
    let id: Int
    let lastName: String
    let secondName: String
}

enum LessonType: String {
    case lecture
    case seminar
    case practice

    func bgColor() -> UIColor {
        switch self {
        case .lecture:
            return .Pallette.green
        case .seminar:
            return .Pallette.blue
        case .practice:
            return .Pallette.skyBlue
        }
    }

    func toText() -> String {
        switch self {
        case .lecture:
            return "Лекция"
        case .seminar:
            return "Семинар"
        case .practice:
            return "Практика"
        }
    }
}

extension LessonType: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawString = try container.decode(String.self)

        if let userType = LessonType(rawValue: rawString.lowercased()) {
            self = userType
        } else {
            throw DecodingError.dataCorruptedError(in: container,
                                                   debugDescription: "Cannot initialize UserType from invalid String value \(rawString)")
        }
    }
}
