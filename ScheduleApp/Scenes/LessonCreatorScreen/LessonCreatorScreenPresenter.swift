//
//  LessonCreatorScreenPresenter.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 28.10.2022.
//

import AsyncPlus
import Foundation

final class LessonCreatorScreenPresenter {
    // MARK: - Private properties -

    private unowned let view: LessonCreatorScreenViewInterface
    private let interactor: LessonCreatorScreenInteractorInterface
    private let wireframe: LessonCreatorScreenWireframeInterface
    private(set) var course: CourseModel
    private(set) var lesson: LessonModel?
    private let completion: (LessonModel?) -> Void

    // MARK: - Lifecycle -

    init(
        view: LessonCreatorScreenViewInterface,
        interactor: LessonCreatorScreenInteractorInterface,
        wireframe: LessonCreatorScreenWireframeInterface,
        course: CourseModel,
        lesson: LessonModel? = nil,
        completion: @escaping (LessonModel?) -> Void
    ) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
        self.course = course
        self.lesson = lesson
        self.completion = completion
    }
}

// MARK: - Extensions -

extension LessonCreatorScreenPresenter: LessonCreatorScreenPresenterInterface {
    var title: String {
        lesson == nil ? "Новый урок" : "Изменить урок"
    }

    func commit(_ lesson: CreateLessonModel) {
        if let initialLesson = self.lesson {
            updateLesson(.init(id: initialLesson.id, title: lesson.title,
                               description: lesson.description, teacherId: lesson.teacherId,
                               courseId: lesson.courseId, startDateTime: lesson.startDateTime,
                               endDateTime: lesson.endDateTime, lessonType: lesson.lessonType))
        } else {
            createLesson(lesson)
        }
    }

    private func createLesson(_ lesson: CreateLessonModel) {
        wireframe.showLoadingBar()
        attempt {
            try await self.interactor.createLesson(lesson)
        }.then { lesson in
            self.wireframe.hideLoadingBar()
            self.completion(lesson)
        }.catch { _ in
            self.wireframe.hideLoadingBar()
            self.completion(nil)
            self.wireframe.showAlert(title: "Error adding lesson", message: nil, preset: .error, presentSide: .top)
        }
    }

    private func updateLesson(_ lesson: UpdateLessonModel) {
        wireframe.showLoadingBar()
        attempt {
            try await self.interactor.updateLesson(lesson)
        }.then { lesson in
            self.wireframe.hideLoadingBar()
            self.completion(lesson)
        }.catch { _ in
            self.wireframe.hideLoadingBar()
            self.completion(nil)
            self.wireframe.showAlert(title: "Error updating lesson", message: nil, preset: .error, presentSide: .top)
        }
    }
}
