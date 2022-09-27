//
//  CoursesCreatorScreenWireframe.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 27.09.2022.
//

import UIKit

public final class CoursesCreatorScreenWireframe: BaseWireframe<CoursesCreatorScreenViewController> {

    // MARK: - Private properties -

    // MARK: - Module setup -

    public init() {
        let moduleViewController = CoursesCreatorScreenViewController()
        super.init(viewController: moduleViewController)

        let interactor = CoursesCreatorScreenInteractor()
        let presenter = CoursesCreatorScreenPresenter(view: moduleViewController, interactor: interactor, wireframe: self)
        moduleViewController.presenter = presenter
    }

}

// MARK: - Extensions -

extension CoursesCreatorScreenWireframe: CoursesCreatorScreenWireframeInterface {
}
