//
//  LessonCreatorScreenInteractor.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 28.10.2022.
//

import Foundation

final class LessonCreatorScreenInteractor {
    private let lessonsService: LessonsService

    init(lessonsService: LessonsService = BasicLessonsService()) {
        self.lessonsService = lessonsService
    }
}

// MARK: - Extensions -

extension LessonCreatorScreenInteractor: LessonCreatorScreenInteractorInterface {
    func createLesson(_ lesson: CreateLessonModel) async throws -> LessonModel {
        try await lessonsService.createLesson(lesson)
    }

    func updateLesson(_ lesson: UpdateLessonModel) async throws -> LessonModel {
        try await lessonsService.updateLesson(lesson)
    }
}
