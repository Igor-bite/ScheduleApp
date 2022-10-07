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

    // MARK: - Lifecycle -

    init(
        view: CoursesCreatorScreenViewInterface,
        interactor: CoursesCreatorScreenInteractorInterface,
        wireframe: CoursesCreatorScreenWireframeInterface
    ) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

// MARK: - Extensions -

extension CoursesCreatorScreenPresenter: CoursesCreatorScreenPresenterInterface {
    public func createCourse(_ course: CreateCourseModel) {
        attempt {
            try await self.interactor.createCourse(course)
        }.then { course in
            print("Created new course: \(course)")
            dump(course)
//            self.updatePresentedCourses()
        }.catch { error in
            self.wireframe.showAlert(title: "Error adding course", message: nil, preset: .error, presentSide: .top)
        }
    }
}
