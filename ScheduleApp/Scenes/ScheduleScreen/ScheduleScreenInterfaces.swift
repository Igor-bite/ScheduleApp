//
//  MainScreenInterfaces.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 15.09.2022.
//

import UIKit

protocol ScheduleScreenWireframeInterface: WireframeInterface {
    func showLessonMaker(forLesson lesson: LessonModel?, courseId: Int, completion: @escaping (LessonModel?) -> Void)
}

protocol ScheduleScreenViewInterface: ViewInterface {
    func reloadData()
    func refresh()
}

protocol ScheduleScreenPresenterInterface: PresenterInterface {
    var numberOfItems: Int { get }

    func item(at indexPath: IndexPath) -> LessonModel
    func itemSelected(at indexPath: IndexPath)
    func fetchLessons()
    func changeLesson(_ lesson: LessonModel)
    func removeLesson(atIndexPath indexPath: IndexPath)

    func setDate(_ date: Date)
}

protocol ScheduleScreenInteractorInterface: InteractorInterface {
    func getAllLessons() async throws -> [LessonModel]
    func removeLesson(_ lesson: LessonModel) async throws
}
