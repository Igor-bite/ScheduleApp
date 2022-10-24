//
//  MockedLessonsService.swift
//  ScheduleAppTests
//
//  Created by Игорь Клюжев on 26.09.2022.
//

@testable import ScheduleApp

final class MockedLessonsService: LessonsService {
    static let lessons = [
        LessonModel(
            id: 1, title: "Lesson",
            description: "Description", teacherId: 1,
            teacher: .init(firstName: "Максим", id: 1, lastName: "Юрьевич", secondName: "Скоринов"),
            courseId: 1, startDateTime: .init(),
            endDateTime: .init(), lessonType: .lecture
        )
    ]

    func getLessons() async throws -> [LessonModel] {
        MockedLessonsService.lessons
    }
}
