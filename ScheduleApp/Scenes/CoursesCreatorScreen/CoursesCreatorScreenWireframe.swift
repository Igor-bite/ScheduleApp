//
//  CoursesCreatorScreenWireframe.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 27.09.2022.
//

import UIKit

final class CoursesCreatorScreenWireframe: BaseWireframe<CoursesCreatorScreenViewController> {
    // MARK: - Private properties -

    // MARK: - Module setup -

    init(course: CourseModel? = nil, completion: @escaping (CourseModel?) -> Void) {
        let moduleViewController = CoursesCreatorScreenViewController()
        super.init(viewController: moduleViewController)

        let interactor = CoursesCreatorScreenInteractor()
        let presenter = CoursesCreatorScreenPresenter(view: moduleViewController,
                                                      interactor: interactor,
                                                      wireframe: self,
                                                      course: course,
                                                      completion: completion)
        moduleViewController.presenter = presenter
    }
}

// MARK: - Extensions -

extension CoursesCreatorScreenWireframe: CoursesCreatorScreenWireframeInterface {}
