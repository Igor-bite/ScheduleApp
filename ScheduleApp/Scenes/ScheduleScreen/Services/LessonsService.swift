//
//  LessonsService.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 20.09.2022.
//

import Foundation

protocol LessonsService {
    func getLessons() async throws -> [LessonModel]
}

final class BasicLessonsService: LessonsService {
    private let network = NetworkService.shared

    func getLessons() async throws -> [LessonModel] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try await network.request(LessonTarget.enrolled).map([LessonModel].self, using: decoder)
    }
}
