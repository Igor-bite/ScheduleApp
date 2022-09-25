//
//  LessonModel.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 15.09.2022.
//

import UIKit

public struct LessonModel: Codable {
	var id: Int
	var title: String
	var description: String
	var teacherId: Int
	var courseId: Int
	var startDateTime: Date
	var endDateTime: Date
}

enum LessonType: String {
	case lection = "Лекция"
	case seminar = "Семинар"
	case practice = "Практика"

	func bgColor() -> UIColor {
		switch self {
		case .lection:
			return .init(red: 60 / 255, green: 207 / 255, blue: 78 / 255, alpha: 1)
		case .seminar:
			return .purple
		case .practice:
			return .blueColor
		}
	}
}
