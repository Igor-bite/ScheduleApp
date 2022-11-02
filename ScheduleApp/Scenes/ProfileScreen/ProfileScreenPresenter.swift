//
//  ProfileScreenPresenter.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 31.10.2022.
//

import AsyncPlus
import Foundation

final class ProfileScreenPresenter {
    // MARK: - Private properties -

    private unowned let view: ProfileScreenViewInterface
    private let interactor: ProfileScreenInteractorInterface
    private let wireframe: ProfileScreenWireframeInterface
    var currentUser: UserModel?

    // MARK: - Lifecycle -

    init(
        view: ProfileScreenViewInterface,
        interactor: ProfileScreenInteractorInterface,
        wireframe: ProfileScreenWireframeInterface,
        user: UserModel? = AuthService.shared.currentUser
    ) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
        currentUser = user
    }
}

// MARK: - Extensions -

extension ProfileScreenPresenter: ProfileScreenPresenterInterface {
    var shouldShowCreateButton: Bool {
        currentUser?.isAdmin ?? false
    }

    func saveChanges(firstName: String, secondName: String, lastName: String) {
        guard let currentUser = currentUser,
              let credencials = AuthService.shared.credencials,
              let user = credencials.user,
              let pass = credencials.password
        else { return }
        attempt {
            let updateUser = UpdateUserModel(username: user, password: pass, firstName: firstName,
                                             lastName: lastName, secondName: secondName, id: currentUser.id,
                                             birthday: .init())
            return try await self.interactor.update(user: updateUser)
        }.then { _ in
            self.wireframe.showAlert(title: "Saved", message: nil, preset: .done, presentSide: .top)
        }.catch { _ in
            self.wireframe.showAlert(title: "Error saving", message: nil, preset: .error, presentSide: .top)
        }
    }

    func changePassword() {
        wireframe.showPasswordChangeScreen()
    }

    func removeAccount() {
        attempt {
            try await self.interactor.removeAccount(user: nil)
        }.then { _ in
            self.logout()
            self.wireframe.showAlert(title: "Removed account", message: nil, preset: .done, presentSide: .top)
        }.catch { _ in
            self.wireframe.showAlert(title: "Error removing", message: nil, preset: .error, presentSide: .top)
        }
    }

    func logout() {
        interactor.logout()
    }

    func createNewUser() {
        wireframe.showUserCreatorScreen()
    }
}
