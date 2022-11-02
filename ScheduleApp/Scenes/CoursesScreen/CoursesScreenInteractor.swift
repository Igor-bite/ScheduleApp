//
//  CoursesScreenInteractor.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 27.09.2022.
//

import Foundation

final class CoursesScreenInteractor {
    private let coursesService: CoursesService

    init(coursesService: CoursesService = BasicCoursesService()) {
        self.coursesService = coursesService
    }
}

// MARK: - Extensions -

extension CoursesScreenInteractor: CoursesScreenInteractorInterface {
    func getAllCourses() async throws -> [CourseModel] {
        try await coursesService.getAllCourses()
    }

    func getEnrolledCourses() async throws -> [CourseModel] {
        try await coursesService.getEnrolledCourses()
    }

    func enrollOnCourse(_ course: CourseModel) {
        coursesService.enrollOnCourse(course)
    }

    func leaveCourse(_ course: CourseModel) {
        coursesService.leaveCourse(course)
    }

    func removeCourse(_ course: CourseModel) async throws {
        try await coursesService.delete(course)
    }
}
