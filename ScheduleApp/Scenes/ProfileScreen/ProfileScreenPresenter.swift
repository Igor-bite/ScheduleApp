//
//  ProfileScreenPresenter.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 31.10.2022.
//

import Foundation

final class ProfileScreenPresenter {
    // MARK: - Private properties -

    private unowned let view: ProfileScreenViewInterface
    private let interactor: ProfileScreenInteractorInterface
    private let wireframe: ProfileScreenWireframeInterface

    // MARK: - Lifecycle -

    init(
        view: ProfileScreenViewInterface,
        interactor: ProfileScreenInteractorInterface,
        wireframe: ProfileScreenWireframeInterface
    ) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

// MARK: - Extensions -

extension ProfileScreenPresenter: ProfileScreenPresenterInterface {}
