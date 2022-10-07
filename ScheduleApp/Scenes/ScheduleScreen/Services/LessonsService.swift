//
//  LessonsService.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 20.09.2022.
//

import Alamofire
import Foundation

protocol LessonsService {
    func getLessons() async throws -> [LessonModel]
}

final class BasicLessonsService: LessonsService {
    func getLessons() async throws -> [LessonModel] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try await AF.request(Constants.Network.baseUrl + "/lesson")
            .authenticate(username: "admin", password: "admin")
            .serializingDecodable([LessonModel].self, decoder: decoder)
            .value
    }
}
