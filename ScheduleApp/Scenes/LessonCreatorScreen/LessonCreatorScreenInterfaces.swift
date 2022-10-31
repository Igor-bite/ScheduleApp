//
//  LessonCreatorScreenInterfaces.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 28.10.2022.
//

import UIKit

protocol LessonCreatorScreenWireframeInterface: WireframeInterface {}

protocol LessonCreatorScreenViewInterface: ViewInterface {}

protocol LessonCreatorScreenPresenterInterface: PresenterInterface {
    var title: String { get }
    var courseId: Int { get }
    var lesson: LessonModel? { get }
    func commit(_ lesson: CreateLessonModel)
}

protocol LessonCreatorScreenInteractorInterface: InteractorInterface {
    func createLesson(_ lesson: CreateLessonModel) async throws -> LessonModel
    func updateLesson(_ lesson: UpdateLessonModel) async throws -> LessonModel
}
