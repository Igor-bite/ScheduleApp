//
//  CoursesCreatorScreenInterfaces.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 27.09.2022.
//

import UIKit

protocol CoursesCreatorScreenWireframeInterface: WireframeInterface {}

protocol CoursesCreatorScreenViewInterface: ViewInterface {}

protocol CoursesCreatorScreenPresenterInterface: PresenterInterface {
    var title: String { get }
    var course: CourseModel? { get }
    func commit(_ course: CreateCourseModel)
}

protocol CoursesCreatorScreenInteractorInterface: InteractorInterface {
    func createCourse(_ course: CreateCourseModel) async throws -> CourseModel
    func updateCourse(_ course: UpdateCourseModel) async throws -> CourseModel
}
