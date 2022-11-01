//
//  PasswordChangeScreenPresenter.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 01.11.2022.
//

import AsyncPlus
import Foundation

final class PasswordChangeScreenPresenter {
    // MARK: - Private properties -

    private unowned let view: PasswordChangeScreenViewInterface
    private let interactor: PasswordChangeScreenInteractorInterface
    private let wireframe: PasswordChangeScreenWireframeInterface

    // MARK: - Lifecycle -

    init(
        view: PasswordChangeScreenViewInterface,
        interactor: PasswordChangeScreenInteractorInterface,
        wireframe: PasswordChangeScreenWireframeInterface
    ) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

// MARK: - Extensions -

extension PasswordChangeScreenPresenter: PasswordChangeScreenPresenterInterface {
    func validateCurrentPassword(pass: String) -> Bool {
        pass == AuthService.shared.credencials?.password
    }

    func changePassword(new: String) {
        guard let curUser = AuthService.shared.currentUser,
              let username = AuthService.shared.credencials?.user
        else { return }
        attempt {
            let new = UpdateUserModel(username: username, password: new, firstName: curUser.firstName,
                                      lastName: curUser.lastName, secondName: curUser.secondName, id: curUser.id)
            return try await self.interactor.update(user: new)
        }.then { _ in
            try await AuthService.shared.signIn(withUsername: username, password: new)
        }.then { _ in
            self.wireframe.showAlert(title: "Success", message: "Password changed", preset: .done, presentSide: .top)
        }.catch { _ in
            self.wireframe.showAlert(title: "Error changing password", message: nil, preset: .error, presentSide: .top)
        }
    }
}
