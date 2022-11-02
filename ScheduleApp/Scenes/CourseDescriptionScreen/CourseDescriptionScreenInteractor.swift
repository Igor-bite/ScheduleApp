//
//  CourseDescriptionScreenInteractor.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 25.10.2022.
//

import Foundation

final class CourseDescriptionScreenInteractor {
    private let courseService = BasicCoursesService()
    private let lessonsService = BasicLessonsService()
}

// MARK: - Extensions -

extension CourseDescriptionScreenInteractor: CourseDescriptionScreenInteractorInterface {
    func delete(_ course: CourseModel) {
        courseService.delete(course)
    }

    func clone(_ course: CourseModel) {
        courseService.clone(course)
    }

    func enroll(_ course: CourseModel) {
        courseService.enrollOnCourse(course)
    }

    func leave(_ course: CourseModel) {
        courseService.leaveCourse(course)
    }

    func lessons(_ course: CourseModel) async throws -> [LessonModel] {
        try await courseService.lessons(course)
    }

    func removeLesson(_ lesson: LessonModel) async throws {
        try await lessonsService.removeLesson(lesson)
    }
}
