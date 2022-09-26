//
//  CoursesScreenInterfaces.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 27.09.2022.
//

import UIKit

public protocol CoursesScreenWireframeInterface: WireframeInterface {
}

public protocol CoursesScreenViewInterface: ViewInterface {
	func reloadData()
	func refresh()
}

public protocol CoursesScreenPresenterInterface: PresenterInterface {
	var numberOfItems: Int { get }

	func item(at indexPath: IndexPath) -> CourseModel
	func itemSelected(at indexPath: IndexPath)
	func fetchLessons()
}

public protocol CoursesScreenInteractorInterface: InteractorInterface {
	func getAllCourses() async throws -> [CourseModel]
}
