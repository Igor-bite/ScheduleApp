//
//  MainScreenWireframe.swift
//  Core
//
//  Created by Игорь Клюжев on 15.09.2022.
//

import UIKit

public final class MainScreenWireframe: BaseWireframe<MainScreenViewController> {

    // MARK: - Private properties -

    // MARK: - Module setup -

    public init() {
        let moduleViewController = MainScreenViewController()
        super.init(viewController: moduleViewController)

        let formatter = MainScreenFormatter()
        let interactor = MainScreenInteractor()
        let presenter = MainScreenPresenter(view: moduleViewController, formatter: formatter, interactor: interactor, wireframe: self)
        moduleViewController.presenter = presenter
    }

}

// MARK: - Extensions -

extension MainScreenWireframe: MainScreenWireframeInterface {
}
