//
//  PasswordChangeScreenWireframe.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 01.11.2022.
//

import UIKit

final class PasswordChangeScreenWireframe: BaseWireframe<PasswordChangeScreenViewController> {
    // MARK: - Private properties -

    // MARK: - Module setup -

    init() {
        let moduleViewController = PasswordChangeScreenViewController()
        super.init(viewController: moduleViewController)

        let interactor = PasswordChangeScreenInteractor()
        let presenter = PasswordChangeScreenPresenter(view: moduleViewController, interactor: interactor, wireframe: self)
        moduleViewController.presenter = presenter
    }
}

// MARK: - Extensions -

extension PasswordChangeScreenWireframe: PasswordChangeScreenWireframeInterface {}
