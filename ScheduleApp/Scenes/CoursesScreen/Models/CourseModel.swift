//
//  CourseModel.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 27.09.2022.
//

import UIKit

public struct CourseModel: Codable {
    enum CourseType: Codable {
        case base(BaseCourseType)
        case online(OnlineCourseType)
        case offline(OfflineCourseType)

        struct BaseCourseType: Codable {
            static let typeName = "base"

            let type: String
        }

        struct OfflineCourseType: Codable {
            static let typeName = "offline"

            let type: String
            let universityName: String?
            let address: String?
        }

        struct OnlineCourseType: Codable {
            static let typeName = "online"

            let type: String
            let lessonUrl: String?
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(BaseCourseType.self),
               value.type == BaseCourseType.typeName
            {
                self = .base(value)
                return
            }
            if let value = try? container.decode(OnlineCourseType.self),
               value.type == OnlineCourseType.typeName
            {
                self = .online(value)
                return
            }
            if let value = try? container.decode(OfflineCourseType.self),
               value.type == OfflineCourseType.typeName
            {
                self = .offline(value)
                return
            }
            throw DecodingError.typeMismatch(
                CourseType.self,
                DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Type is not matched", underlyingError: nil)
            )
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .base(let value):
                try container.encode(value)
            case .online(let value):
                try container.encode(value)
            case .offline(let value):
                try container.encode(value)
            }
        }

        func toText() -> String {
            switch self {
            case .base:
                return ""
            case .online:
                return "Онлайн"
            case .offline:
                return "Оффлайн"
            }
        }

        func bgColor() -> UIColor {
            switch self {
            case .base:
                return .Pallette.toxicBlue
            case .online:
                return .Pallette.blue
            case .offline:
                return .Pallette.skyBlue
            }
        }
    }

    let id: Int
    let title: String
    let description: String
    let categoryId: Int
    let curatorId: Int
    let type: CourseType

    func placeInfo() -> (university: String?, place: String?) {
        switch type {
        case .base:
            return (nil, nil)
        case .online(let onlineInfo):
            guard let lessonUrl = onlineInfo.lessonUrl else { return (nil, nil) }
            return (nil, "🔗 \(lessonUrl)")
        case .offline(let offlineInfo):
            switch (offlineInfo.universityName?.nilIfEmpty, offlineInfo.address?.nilIfEmpty) {
            case (.some(let uni), .some(let address)):
                return ("🎓\(uni)", "📍\(address)")
            case (nil, .some(let address)):
                return (nil, "📍\(address)")
            case (.some(let uni), nil):
                return ("🎓\(uni)", nil)
            case (nil, nil):
                return (nil, nil)
            }
        }
    }
}

public struct CreateCourseModel: Codable {
    let title: String
    let description: String
    let categoryId: Int
    let curatorId: Int
    let type: CourseModel.CourseType
}
