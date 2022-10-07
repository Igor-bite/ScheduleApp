//
//  CoursesCreatorScreenInterfaces.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 27.09.2022.
//

import UIKit

public protocol CoursesCreatorScreenWireframeInterface: WireframeInterface {}

public protocol CoursesCreatorScreenViewInterface: ViewInterface {}

public protocol CoursesCreatorScreenPresenterInterface: PresenterInterface {
    func createCourse(_ course: CreateCourseModel)
}

public protocol CoursesCreatorScreenInteractorInterface: InteractorInterface {
    func createCourse(_ course: CreateCourseModel) async throws -> CourseModel
}
