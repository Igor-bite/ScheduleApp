//
//  AuthScreenWireframe.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 24.10.2022.
//

import UIKit

final class AuthScreenWireframe: BaseWireframe<AuthScreenViewController> {
    // MARK: - Private properties -

    private let showMain: () -> Void

    // MARK: - Module setup -

    init(showMain: @escaping () -> Void) {
        self.showMain = showMain

        let moduleViewController = AuthScreenViewController()
        super.init(viewController: moduleViewController)

        let interactor = AuthScreenInteractor()
        let presenter = AuthScreenPresenter(view: moduleViewController, interactor: interactor, wireframe: self)
        moduleViewController.presenter = presenter
    }
}

// MARK: - Extensions -

extension AuthScreenWireframe: AuthScreenWireframeInterface {
    func navigateToMain() {
        DispatchQueue.main.async {
            self.showMain()
        }
    }
}
