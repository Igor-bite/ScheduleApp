//
//  CoursesScreenWireframe.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 27.09.2022.
//

import UIKit

final class CoursesScreenWireframe: BaseWireframe<CoursesScreenViewController> {
    // MARK: - Private properties -

    // MARK: - Module setup -

    init() {
        let moduleViewController = CoursesScreenViewController()
        super.init(viewController: moduleViewController)

        let interactor = CoursesScreenInteractor()
        let presenter = CoursesScreenPresenter(view: moduleViewController, interactor: interactor, wireframe: self)
        moduleViewController.presenter = presenter
    }
}

// MARK: - Extensions -

extension CoursesScreenWireframe: CoursesScreenWireframeInterface {
    func presentCourseCreator(completion: @escaping (CourseModel?) -> Void) {
        navigationController?.presentWireframe(CoursesCreatorScreenWireframe(completion: completion))
    }

    func presentCourseDescription(course: CourseModel) {
        navigationController?.pushWireframe(CourseDescriptionScreenWireframe(course: course))
    }
}
