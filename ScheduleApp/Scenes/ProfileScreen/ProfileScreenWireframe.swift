//
//  ProfileScreenWireframe.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 31.10.2022.
//

import UIKit

final class ProfileScreenWireframe: BaseWireframe<ProfileScreenViewController> {
    // MARK: - Private properties -

    // MARK: - Module setup -

    init() {
        let moduleViewController = ProfileScreenViewController()
        super.init(viewController: moduleViewController)

        let interactor = ProfileScreenInteractor()
        let presenter = ProfileScreenPresenter(view: moduleViewController, interactor: interactor, wireframe: self)
        moduleViewController.presenter = presenter
    }
}

// MARK: - Extensions -

extension ProfileScreenWireframe: ProfileScreenWireframeInterface {
    func showPasswordChangeScreen() {
        navigationController?.presentWireframe(PasswordChangeScreenWireframe())
    }

    func showUserCreatorScreen() {}
}
