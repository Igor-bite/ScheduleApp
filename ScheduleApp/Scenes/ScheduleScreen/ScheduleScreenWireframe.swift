//
//  ScheduleScreenWireframe.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 15.09.2022.
//

import UIKit

final class ScheduleScreenWireframe: BaseWireframe<ScheduleScreenViewController> {
    // MARK: - Private properties -

    // MARK: - Module setup -

    init() {
        let moduleViewController = ScheduleScreenViewController()
        super.init(viewController: moduleViewController)

        let interactor = ScheduleScreenInteractor()
        let presenter = ScheduleScreenPresenter(view: moduleViewController,
                                                interactor: interactor,
                                                wireframe: self)
        moduleViewController.presenter = presenter
    }
}

// MARK: - Extensions -

extension ScheduleScreenWireframe: ScheduleScreenWireframeInterface {
    func showLessonMaker(forLesson lesson: LessonModel?, courseId: Int, completion: @escaping (LessonModel?) -> Void) {
        navigationController?.presentWireframe(LessonCreatorScreenWireframe(courseId: courseId, lesson: lesson, completion: completion))
    }
}
