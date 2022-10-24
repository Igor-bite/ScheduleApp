//
//  CoursesCreatorScreenInteractor.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 27.09.2022.
//

import Foundation

final class CoursesCreatorScreenInteractor {
    private let coursesService: CoursesService

    init(coursesService: CoursesService = BasicCoursesService()) {
        self.coursesService = coursesService
    }
}

// MARK: - Extensions -

extension CoursesCreatorScreenInteractor: CoursesCreatorScreenInteractorInterface {
    func createCourse(_ course: CreateCourseModel) async throws -> CourseModel {
        try await coursesService.createCourse(course)
    }
}
