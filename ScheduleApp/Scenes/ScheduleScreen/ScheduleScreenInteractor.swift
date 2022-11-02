//
//  ScheduleScreenInteractor.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 15.09.2022.
//

import Foundation

final class ScheduleScreenInteractor {
    private let lessonsService: LessonsService

    init(lessonsService: LessonsService = BasicLessonsService()) {
        self.lessonsService = lessonsService
    }
}

// MARK: - Extensions -

extension ScheduleScreenInteractor: ScheduleScreenInteractorInterface {
    func getAllLessons() async throws -> [LessonModel] {
        try await lessonsService.getLessons()
    }

    func removeLesson(_ lesson: LessonModel) async throws {
        try await lessonsService.removeLesson(lesson)
    }
}
