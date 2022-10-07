//
//  CoursesService.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 27.09.2022.
//

import Foundation
import Alamofire

protocol CoursesService {
	func getCourses() async throws -> [CourseModel]
    func createCourse(_ course: CreateCourseModel) async throws -> CourseModel
}

final class BasicCoursesService: CoursesService {
	func getCourses() async throws -> [CourseModel] {
		try await AF.request(Constants.Network.baseUrl + "/course")
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
}
