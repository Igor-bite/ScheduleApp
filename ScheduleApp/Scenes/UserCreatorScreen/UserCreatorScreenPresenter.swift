//
//  UserCreatorScreenPresenter.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 01.11.2022.
//

import AsyncPlus
import Foundation

final class UserCreatorScreenPresenter {
    // MARK: - Private properties -

    private unowned let view: UserCreatorScreenViewInterface
    private let interactor: UserCreatorScreenInteractorInterface
    private let wireframe: UserCreatorScreenWireframeInterface

    // MARK: - Lifecycle -

    init(
        view: UserCreatorScreenViewInterface,
        interactor: UserCreatorScreenInteractorInterface,
        wireframe: UserCreatorScreenWireframeInterface
    ) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

// MARK: - Extensions -

extension UserCreatorScreenPresenter: UserCreatorScreenPresenterInterface {
    func create(user: CreateUserModel) {
        attempt {
            try await self.interactor.create(user: user)
        }.then { _ in
            self.wireframe.showAlert(title: "Created user", message: nil, preset: .done, presentSide: .top)
        }.catch { _ in
            self.wireframe.showAlert(title: "Error creating user", message: nil, preset: .error, presentSide: .top)
        }
    }
}
