//
//  MockedLessonsService.swift
//  ScheduleAppTests
//
//  Created by Игорь Клюжев on 26.09.2022.
//  Copyright © 2022 messeb.com. All rights reserved.
//

@testable import ScheduleApp

final class MockedLessonsService: LessonsService {
	static let lessons = [LessonModel(id: 1, title: "Lesson", description: "Description", teacherId: 1, courseId: 1, startDateTime: .init(), endDateTime: .init())]

	func getLessons() async throws -> [LessonModel] {
		MockedLessonsService.lessons
	}
}
