//
//  RegistrationScreenPresenter.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 24.10.2022.
//

import AsyncPlus
import Foundation

final class RegistrationScreenPresenter {
    // MARK: - Private properties -

    private unowned let view: RegistrationScreenViewInterface
    private let interactor: RegistrationScreenInteractorInterface
    private let wireframe: RegistrationScreenWireframeInterface

    // MARK: - Lifecycle -

    init(
        view: RegistrationScreenViewInterface,
        interactor: RegistrationScreenInteractorInterface,
        wireframe: RegistrationScreenWireframeInterface
    ) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

// MARK: - Extensions -

extension RegistrationScreenPresenter: RegistrationScreenPresenterInterface {
    func login() {
        attempt {
            try await self.interactor.login()
        }.then { user in
            print(user)
            self.wireframe.navigateToMain()
        }.catch { _ in
            self.wireframe.showAlert(title: "Error loging in", message: nil, preset: .error, presentSide: .top)
        }
    }
}
