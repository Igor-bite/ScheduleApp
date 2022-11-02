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
    func removeLesson(_ lesson: LessonModel) async throws
}

final class BasicLessonsService: LessonsService {
    private let network = NetworkService.shared

    private var decoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

    func getLessons() async throws -> [LessonModel] {
        if let curUser = AuthService.shared.currentUser,
           curUser.isAdmin
        {
            return try await network.request(LessonTarget.all).map([LessonModel].self, using: decoder)
        }
        let enrolled = try await network.request(LessonTarget.enrolled).map([LessonModel].self, using: decoder)
        let taught = try await network.request(LessonTarget.taught).map([LessonModel].self, using: decoder)
        return taught + enrolled
    }

    func createLesson(_ lesson: CreateLessonModel) async throws -> LessonModel {
        try await network.request(LessonTarget.create(lesson)).map(LessonModel.self, using: decoder)
    }

    func updateLesson(_ lesson: UpdateLessonModel) async throws -> LessonModel {
        try await network.request(LessonTarget.update(lesson)).map(LessonModel.self, using: decoder)
    }

    func removeLesson(_ lesson: LessonModel) async throws {
        _ = try await network.request(LessonTarget.delete(id: lesson.id))
    }
}
