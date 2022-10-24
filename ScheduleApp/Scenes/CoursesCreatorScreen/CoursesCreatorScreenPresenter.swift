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
    private let completion: (CourseModel?) -> Void

    // MARK: - Lifecycle -

    init(
        view: CoursesCreatorScreenViewInterface,
        interactor: CoursesCreatorScreenInteractorInterface,
        wireframe: CoursesCreatorScreenWireframeInterface,
        completion: @escaping (CourseModel?) -> Void
    ) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
        self.completion = completion
    }
}

// MARK: - Extensions -

extension CoursesCreatorScreenPresenter: CoursesCreatorScreenPresenterInterface {
    func createCourse(_ course: CreateCourseModel) {
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
}
