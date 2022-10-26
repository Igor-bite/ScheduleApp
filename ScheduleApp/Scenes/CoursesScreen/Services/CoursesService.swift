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
    func lessons(_ course: CourseModel) async throws -> [LessonModel]
    func delete(_ course: CourseModel)
    func clone(_ course: CourseModel)
}

final class BasicCoursesService: CoursesService {
    func lessons(_ course: CourseModel) async throws -> [LessonModel] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try await network.request(CourseTarget.lessons(id: course.id)).map([LessonModel].self, using: decoder)
    }

    func delete(_ course: CourseModel) {
        network.request(CourseTarget.delete(id: course.id)) { result in
            print(result)
        }
    }

    func clone(_ course: CourseModel) {
        network.request(CourseTarget.clone(id: course.id)) { result in
            print(result)
        }
    }

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
