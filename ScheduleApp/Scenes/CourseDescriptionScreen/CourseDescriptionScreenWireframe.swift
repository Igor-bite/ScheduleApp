//
//  CourseDescriptionScreenWireframe.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 25.10.2022.
//

import UIKit

final class CourseDescriptionScreenWireframe: BaseWireframe<CourseDescriptionScreenViewController> {
    // MARK: - Private properties -

    // MARK: - Module setup -

    init(course: CourseModel) {
        let moduleViewController = CourseDescriptionScreenViewController()
        super.init(viewController: moduleViewController)

        let interactor = CourseDescriptionScreenInteractor()
        let presenter = CourseDescriptionScreenPresenter(view: moduleViewController, interactor: interactor,
                                                         wireframe: self, course: course)
        moduleViewController.presenter = presenter
    }
}

// MARK: - Extensions -

extension CourseDescriptionScreenWireframe: CourseDescriptionScreenWireframeInterface {
    func goBack() {
        navigationController?.popViewController(animated: true)
    }

    func showCourseChange() {}
}
