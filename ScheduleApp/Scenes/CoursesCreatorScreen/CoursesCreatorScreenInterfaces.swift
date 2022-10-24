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
    func createCourse(_ course: CreateCourseModel)
}

protocol CoursesCreatorScreenInteractorInterface: InteractorInterface {
    func createCourse(_ course: CreateCourseModel) async throws -> CourseModel
}
