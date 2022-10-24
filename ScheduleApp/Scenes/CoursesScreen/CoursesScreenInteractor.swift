//
//  CoursesScreenInteractor.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 27.09.2022.
//

import Foundation

public final class CoursesScreenInteractor {
    private let coursesService: CoursesService

    init(coursesService: CoursesService = BasicCoursesService()) {
        self.coursesService = coursesService
    }
}

// MARK: - Extensions -

extension CoursesScreenInteractor: CoursesScreenInteractorInterface {
    public func getAllCourses() async throws -> [CourseModel] {
        try await coursesService.getCourses()
    }

    public func enrollOnCourse(_ course: CourseModel) {
        coursesService.enrollOnCourse(course)
    }

    public func leaveCourse(_ course: CourseModel) {
        coursesService.leaveCourse(course)
    }
}
