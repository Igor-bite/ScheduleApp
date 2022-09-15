//
//  LessonModel.swift
//  Core
//
//  Created by Игорь Клюжев on 15.09.2022.
//

import Foundation

public struct LessonModel: Codable {
	var id: Int
	var title: String
	var description: String
	var teacherId: Int
	var courseId: Int
	var startDateTime: Date
	var endDateTime: Date
}
