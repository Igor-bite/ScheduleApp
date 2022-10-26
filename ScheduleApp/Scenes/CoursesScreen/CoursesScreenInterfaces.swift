//
//  CoursesScreenInterfaces.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 27.09.2022.
//

import UIKit

protocol CoursesScreenWireframeInterface: WireframeInterface {
    func presentCourseCreator(completion: @escaping (CourseModel?) -> Void)
    func presentCourseDescription(course: CourseModel)
}

protocol CoursesScreenViewInterface: ViewInterface {
    func reloadData()
    func refresh()
    func insertNewCourse(at indexPath: IndexPath)
}

protocol CoursesScreenPresenterInterface: PresenterInterface {
    var numberOfItems: Int { get }

    func item(at indexPath: IndexPath) -> CourseModel
    func itemSelected(at indexPath: IndexPath)
    func fetchLessons()

    func createNewCourse()

    func enrollOnCourse(at indexPath: IndexPath)
    func leaveCourse(at indexPath: IndexPath)

    func logout()
}

protocol CoursesScreenInteractorInterface: InteractorInterface {
    func getAllCourses() async throws -> [CourseModel]
    func getEnrolledCourses() async throws -> [CourseModel]
    func enrollOnCourse(_ course: CourseModel)
    func leaveCourse(_ course: CourseModel)
}
