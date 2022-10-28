//
//  LessonsService.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 20.09.2022.
//

import Foundation

protocol LessonsService {
    func getLessons() async throws -> [LessonModel]
    func createLesson(_ lesson: CreateLessonModel) async throws -> LessonModel
    func updateLesson(_ lesson: UpdateLessonModel) async throws -> LessonModel
}

final class BasicLessonsService: LessonsService {
    private let network = NetworkService.shared

    private var decoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

    func getLessons() async throws -> [LessonModel] {
        return try await network.request(LessonTarget.enrolled).map([LessonModel].self, using: decoder)
    }

    func createLesson(_ lesson: CreateLessonModel) async throws -> LessonModel {
        return try await network.request(LessonTarget.create(lesson)).map(LessonModel.self, using: decoder)
    }

    func updateLesson(_ lesson: UpdateLessonModel) async throws -> LessonModel {
        return try await network.request(LessonTarget.update(lesson)).map(LessonModel.self, using: decoder)
    }
}
