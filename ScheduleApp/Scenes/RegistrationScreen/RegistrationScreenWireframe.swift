//
//  RegistrationScreenWireframe.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 24.10.2022.
//

import UIKit

final class RegistrationScreenWireframe: BaseWireframe<RegistrationScreenViewController> {
    // MARK: - Private properties -

    private let showMain: () -> Void

    // MARK: - Module setup -

    init(showMain: @escaping () -> Void) {
        self.showMain = showMain

        let moduleViewController = RegistrationScreenViewController()
        super.init(viewController: moduleViewController)

        let interactor = RegistrationScreenInteractor()
        let presenter = RegistrationScreenPresenter(view: moduleViewController, interactor: interactor, wireframe: self)
        moduleViewController.presenter = presenter
    }
}

// MARK: - Extensions -

extension RegistrationScreenWireframe: RegistrationScreenWireframeInterface {
    func navigateToMain() {
        DispatchQueue.main.async {
            self.showMain()
        }
    }
}
