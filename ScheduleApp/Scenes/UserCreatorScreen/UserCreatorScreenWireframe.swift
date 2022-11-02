//
//  UserCreatorScreenWireframe.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 01.11.2022.
//

import UIKit

final class UserCreatorScreenWireframe: BaseWireframe<UserCreatorScreenViewController> {
    // MARK: - Private properties -

    // MARK: - Module setup -

    init() {
        let moduleViewController = UserCreatorScreenViewController()
        super.init(viewController: moduleViewController)

        let interactor = UserCreatorScreenInteractor()
        let presenter = UserCreatorScreenPresenter(view: moduleViewController, interactor: interactor, wireframe: self)
        moduleViewController.presenter = presenter
    }
}

// MARK: - Extensions -

extension UserCreatorScreenWireframe: UserCreatorScreenWireframeInterface {}
