//
//  LessonModel.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 15.09.2022.
//

import UIKit

public struct LessonModel: Codable, Equatable {
	var id: Int
	var title: String
	var description: String
	var teacherId: Int
	var courseId: Int
	var startDateTime: Date
	var endDateTime: Date
	var lessonType: LessonType
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
