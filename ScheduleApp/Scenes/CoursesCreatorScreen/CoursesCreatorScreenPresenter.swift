//
//  CoursesCreatorScreenPresenter.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 27.09.2022.
//

import Foundation

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
}
