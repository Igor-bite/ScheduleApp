//
//  ScheduleScreenWireframe.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 15.09.2022.
//

import UIKit

public final class ScheduleScreenWireframe: BaseWireframe<ScheduleScreenViewController> {

    // MARK: - Private properties -

    // MARK: - Module setup -

    public init() {
        let moduleViewController = ScheduleScreenViewController()
        super.init(viewController: moduleViewController)

        let formatter = ScheduleScreenFormatter()
        let interactor = ScheduleScreenInteractor()
        let presenter = ScheduleScreenPresenter(view: moduleViewController, formatter: formatter, interactor: interactor, wireframe: self)
        moduleViewController.presenter = presenter
    }

}

// MARK: - Extensions -

extension ScheduleScreenWireframe: ScheduleScreenWireframeInterface {
}
