//
//  CoursesScreenWireframe.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 27.09.2022.
//

import UIKit

public final class CoursesScreenWireframe: BaseWireframe<CoursesScreenViewController> {

    // MARK: - Private properties -

    // MARK: - Module setup -

    public init() {
        let moduleViewController = CoursesScreenViewController()
        super.init(viewController: moduleViewController)

        let interactor = CoursesScreenInteractor()
        let presenter = CoursesScreenPresenter(view: moduleViewController, interactor: interactor, wireframe: self)
        moduleViewController.presenter = presenter
    }

}

// MARK: - Extensions -

extension CoursesScreenWireframe: CoursesScreenWireframeInterface {
}
