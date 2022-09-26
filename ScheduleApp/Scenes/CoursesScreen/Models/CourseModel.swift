//
//  CourseModel.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 27.09.2022.
//

import Foundation

public struct CourseModel: Codable {
	struct CourseType: Codable {
		enum TypeName: String, Codable {
			case online
			case offline
			case base

			func toText() -> String {
				switch self {
				case .online:
					return "Онлайн"
				case .offline:
					return "Оффлайн"
				case .base:
					return "Базовый"
				}
			}
		}

		let type: TypeName
	}

	let id: Int
	let title: String
	let description: String
	let categoryId: Int
	let curatorId: Int
	let studentCount: Int
	let courseType: CourseType

	enum CodingKeys: String, CodingKey {
		case id = "id"
		case title = "title"
		case description = "description"
		case categoryId = "categoryId"
		case curatorId = "curatorId"
		case studentCount = "studentCount"
		case courseType = "type"
	}
}
