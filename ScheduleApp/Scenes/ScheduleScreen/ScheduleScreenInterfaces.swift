//
//  MainScreenInterfaces.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 15.09.2022.
//

import UIKit

public protocol ScheduleScreenWireframeInterface: WireframeInterface {}

public protocol ScheduleScreenViewInterface: ViewInterface {
    func reloadData()
    func refresh()
}

public protocol ScheduleScreenPresenterInterface: PresenterInterface {
    var numberOfItems: Int { get }

    func item(at indexPath: IndexPath) -> LessonModel
    func itemSelected(at indexPath: IndexPath)
    func fetchLessons()

    func setDate(_ date: Date)
}

public protocol ScheduleScreenInteractorInterface: InteractorInterface {
    func getAllLessons() async throws -> [LessonModel]
}
