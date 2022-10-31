//
//  AuthScreenPresenter.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 24.10.2022.
//

import AsyncPlus
import Foundation
import SPConfetti

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
        wireframe.showLoadingBar()
        attempt {
            try await self.interactor.signIn(withUsername: username, password: password)
        }.then { user in
            print(user)
            self.wireframe.navigateToMain()
            self.wireframe.hideLoadingBar()
        }.catch { _ in
            self.wireframe.showAlert(title: "Error loging in", message: nil, preset: .error, presentSide: .top)
            self.wireframe.hideLoadingBar()
        }
    }

    func signUp(_ user: CreateUserModel) {
        wireframe.showLoadingBar()
        attempt {
            try await self.interactor.signUp(user)
        }.then { _ in
            DispatchQueue.main.async {
                self.wireframe.navigateToMain()
                self.wireframe.hideLoadingBar()
                SPConfetti.startAnimating(.fullWidthToDown, particles: [.star, .triangle, .heart], duration: 4.0)
            }
        }.catch { _ in
            DispatchQueue.main.async {
                self.wireframe.showAlert(title: "Error with sign up", message: nil, preset: .error, presentSide: .top)
                self.wireframe.hideLoadingBar()
            }
        }
    }
}
