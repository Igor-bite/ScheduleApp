//
//  MainScreenInterfaces.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 15.09.2022.
//

import UIKit

public protocol MainScreenWireframeInterface: WireframeInterface {
}

public protocol MainScreenViewInterface: ViewInterface {
	func reloadData()
	func refresh()
}

public protocol MainScreenPresenterInterface: PresenterInterface {
	var numberOfItems: Int { get }

	func item(at indexPath: IndexPath) -> LessonModel
	func itemSelected(at indexPath: IndexPath)
	func loadLessons()
}

public protocol MainScreenFormatterInterface: FormatterInterface {
}

public protocol MainScreenInteractorInterface: InteractorInterface {
	func getAllLessons() async throws -> [LessonModel]
}
