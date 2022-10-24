//
//  CoursesService.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 27.09.2022.
//

import Alamofire
import Foundation

protocol CoursesService {
    func getCourses() async throws -> [CourseModel]
    func createCourse(_ course: CreateCourseModel) async throws -> CourseModel
    func enrollOnCourse(_ course: CourseModel)
    func leaveCourse(_ course: CourseModel)
}

final class BasicCoursesService: CoursesService {
    func getCourses() async throws -> [CourseModel] {
        try await AF.request(Constants.Network.baseUrl + "/course/all")
            .authenticate(username: "admin", password: "admin")
            //        			.authenticate(username: "SomeUsername", password: "SomePassword")
            .serializingDecodable([CourseModel].self)
            .value
    }

    func createCourse(_ course: CreateCourseModel) async throws -> CourseModel {
        try await AF.request(Constants.Network.baseUrl + "/course", method: .post,
                             parameters: course.asDictionary, encoding: JSONEncoding.default)
            .authenticate(username: "admin", password: "admin")
            .serializingDecodable(CourseModel.self)
            .value
    }

    func enrollOnCourse(_ course: CourseModel) {
        AF.request(Constants.Network.baseUrl + "/course/enroll/\(course.id)", method: .put)
            .authenticate(username: "admin", password: "admin").response { response in
                print(response)
            }
    }

    func leaveCourse(_ course: CourseModel) {
        AF.request(Constants.Network.baseUrl + "/course/leave/\(course.id)", method: .put)
            .authenticate(username: "admin", password: "admin").response { response in
                print(response)
            }
    }
}
