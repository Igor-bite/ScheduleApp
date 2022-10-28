//
//  CourseDescriptionScreenInterfaces.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 25.10.2022.
//

import UIKit

protocol CourseDescriptionScreenWireframeInterface: WireframeInterface {
    func goBack()
    func showCourseChange(forCourse course: CourseModel, completion: @escaping (CourseModel?) -> Void)
}

protocol CourseDescriptionScreenViewInterface: ViewInterface {
    func reloadCourseInfo()
    func reloadLessons()
}

protocol CourseDescriptionScreenPresenterInterface: PresenterInterface {
    var course: CourseModel { get }
    var numberOfLessons: Int { get }

    func lesson(forIndexPath indexPath: IndexPath) -> LessonModel?
    func delete()
    func clone()
    func enroll()
    func leave()
    func lessons()
    func change()
    func dismiss()
}

protocol CourseDescriptionScreenInteractorInterface: InteractorInterface {
    func delete(_ course: CourseModel)
    func clone(_ course: CourseModel)
    func enroll(_ course: CourseModel)
    func leave(_ course: CourseModel)
    func lessons(_ course: CourseModel) async throws -> [LessonModel]
}
