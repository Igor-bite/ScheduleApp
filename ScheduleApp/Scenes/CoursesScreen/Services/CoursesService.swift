//
//  CoursesService.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 27.09.2022.
//

import Foundation
import Moya

protocol CoursesService {
    func getAllCourses() async throws -> [CourseModel]
    func getTaughtCourses() async throws -> [CourseModel]
    func getEnrolledCourses() async throws -> [CourseModel]
    func createCourse(_ course: CreateCourseModel) async throws -> CourseModel
    func enrollOnCourse(_ course: CourseModel)
    func leaveCourse(_ course: CourseModel)
}

final class BasicCoursesService: CoursesService {
    private let network = NetworkService.shared

    func getAllCourses() async throws -> [CourseModel] {
        try await network.request(CourseTarget.all).map([CourseModel].self)
    }

    func getTaughtCourses() async throws -> [CourseModel] {
        try await network.request(CourseTarget.taught).map([CourseModel].self)
    }

    func getEnrolledCourses() async throws -> [CourseModel] {
        try await network.request(CourseTarget.enrolled).map([CourseModel].self)
    }

    func createCourse(_ course: CreateCourseModel) async throws -> CourseModel {
        try await network.request(CourseTarget.create(course)).map(CourseModel.self)
    }

    func enrollOnCourse(_ course: CourseModel) {
        network.request(CourseTarget.enroll(id: course.id)) { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }

    func leaveCourse(_ course: CourseModel) {
        network.request(CourseTarget.leave(id: course.id)) { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
}
