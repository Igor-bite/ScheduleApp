//
//  CoursesCreatorScreenPresenter.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 27.09.2022.
//

import Foundation
import AsyncPlus

public final class CoursesCreatorScreenPresenter {

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
    public func createCourse(_ course: CreateCourseModel) {
        attempt {
            try await self.interactor.createCourse(course)
        }.then { course in
            self.completion(course)
        }.catch { error in
            self.completion(nil)
            self.wireframe.showAlert(title: "Error adding course", message: nil, preset: .error, presentSide: .top)
        }
    }
}
