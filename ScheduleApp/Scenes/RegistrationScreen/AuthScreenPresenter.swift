//
//  AuthScreenPresenter.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 24.10.2022.
//

import AsyncPlus
import Foundation

final class AuthScreenPresenter {
    // MARK: - Private properties -

    private unowned let view: AuthScreenViewInterface
    private let interactor: AuthScreenInteractorInterface
    private let wireframe: AuthScreenWireframeInterface

    // MARK: - Lifecycle -

    init(
        view: AuthScreenViewInterface,
        interactor: AuthScreenInteractorInterface,
        wireframe: AuthScreenWireframeInterface
    ) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

// MARK: - Extensions -

extension AuthScreenPresenter: AuthScreenPresenterInterface {
    func signIn(withUsername username: String, password: String) {
        attempt {
            try await self.interactor.signIn(withUsername: username, password: password)
        }.then { user in
            print(user)
            self.wireframe.navigateToMain()
        }.catch { _ in
            self.wireframe.showAlert(title: "Error loging in", message: nil, preset: .error, presentSide: .top)
        }
    }

    func signUp(_ user: CreateUserModel) {
        attempt {
            try await self.interactor.signUp(user)
        }.then { user in
            print(user)
            self.wireframe.navigateToMain()
        }.catch { _ in
            self.wireframe.showAlert(title: "Error with sign up", message: nil, preset: .error, presentSide: .top)
        }
    }
}
