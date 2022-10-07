//
//  CoursesScreenInterfaces.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 27.09.2022.
//

import UIKit

public protocol CoursesScreenWireframeInterface: WireframeInterface {
    func presentCourseCreator(completion: @escaping (CourseModel?) -> Void)
}

public protocol CoursesScreenViewInterface: ViewInterface {
	func reloadData()
	func refresh()
    func insertNewCourse(at indexPath: IndexPath)
}

public protocol CoursesScreenPresenterInterface: PresenterInterface {
	var numberOfItems: Int { get }

	func item(at indexPath: IndexPath) -> CourseModel
	func itemSelected(at indexPath: IndexPath)
	func fetchLessons()

	func createNewCourse()
}

public protocol CoursesScreenInteractorInterface: InteractorInterface {
	func getAllCourses() async throws -> [CourseModel]
}
