//
//  CoursesCreatorScreenPresenter.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 27.09.2022.
//

import AsyncPlus
import Foundation

final class CoursesCreatorScreenPresenter {
    // MARK: - Private properties -

    private unowned let view: CoursesCreatorScreenViewInterface
    private let interactor: CoursesCreatorScreenInteractorInterface
    private let wireframe: CoursesCreatorScreenWireframeInterface
    private(set) var course: CourseModel?
    private let completion: (CourseModel?) -> Void

    // MARK: - Lifecycle -

    init(
        view: CoursesCreatorScreenViewInterface,
        interactor: CoursesCreatorScreenInteractorInterface,
        wireframe: CoursesCreatorScreenWireframeInterface,
        course: CourseModel? = nil,
        completion: @escaping (CourseModel?) -> Void
    ) {
        self.course = course
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
        self.completion = completion
    }
}

// MARK: - Extensions -

extension CoursesCreatorScreenPresenter: CoursesCreatorScreenPresenterInterface {
    var title: String {
        course == nil ? "Новый курс" : "Изменить курс"
    }

    func commit(_ course: CreateCourseModel) {
        if let initialCourse = self.course {
            updateCourse(.init(id: initialCourse.id, title: course.title,
                               description: course.description, categoryId: course.categoryId,
                               curatorId: course.curatorId, type: course.type))
        } else {
            createCourse(course)
        }
    }

    private func createCourse(_ course: CreateCourseModel) {
        wireframe.showLoadingBar()
        attempt {
            try await self.interactor.createCourse(course)
        }.then { course in
            self.wireframe.hideLoadingBar()
            self.completion(course)
        }.catch { _ in
            self.wireframe.hideLoadingBar()
            self.completion(nil)
            self.wireframe.showAlert(title: "Error adding course", message: nil, preset: .error, presentSide: .top)
        }
    }

    private func updateCourse(_ course: UpdateCourseModel) {
        wireframe.showLoadingBar()
        attempt {
            try await self.interactor.updateCourse(course)
        }.then { course in
            self.wireframe.hideLoadingBar()
            self.completion(course)
        }.catch { _ in
            self.wireframe.hideLoadingBar()
            self.completion(nil)
            self.wireframe.showAlert(title: "Error updating course", message: nil, preset: .error, presentSide: .top)
        }
    }
}
