//
//  LessonCreatorScreenWireframe.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 28.10.2022.
//

import UIKit

final class LessonCreatorScreenWireframe: BaseWireframe<LessonCreatorScreenViewController> {
    // MARK: - Private properties -

    // MARK: - Module setup -

    init(courseId: Int, lesson: LessonModel? = nil, completion: @escaping (LessonModel?) -> Void) {
        let moduleViewController = LessonCreatorScreenViewController()
        super.init(viewController: moduleViewController)

        let interactor = LessonCreatorScreenInteractor()
        let presenter = LessonCreatorScreenPresenter(view: moduleViewController, interactor: interactor, wireframe: self, courseId: courseId, lesson: lesson, completion: completion)
        moduleViewController.presenter = presenter
    }
}

// MARK: - Extensions -

extension LessonCreatorScreenWireframe: LessonCreatorScreenWireframeInterface {}
