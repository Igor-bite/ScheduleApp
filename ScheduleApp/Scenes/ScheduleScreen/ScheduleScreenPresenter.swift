//
//  ScheduleScreenPresenter.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 15.09.2022.
//

import AsyncPlus
import Foundation

final class ScheduleScreenPresenter {
    // MARK: - Private properties -

    private unowned let view: ScheduleScreenViewInterface
    private let interactor: ScheduleScreenInteractorInterface
    private let wireframe: ScheduleScreenWireframeInterface

    private var lessonsForChosenDay = [LessonModel]() {
        didSet {
            view.reloadData()
        }
    }

    private var lessons: [LessonModel]?
    private var selectedDate = Date()

    // MARK: - Lifecycle -

    init(
        view: ScheduleScreenViewInterface,
        interactor: ScheduleScreenInteractorInterface,
        wireframe: ScheduleScreenWireframeInterface
    ) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe

        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: .AppDidBecomeActive, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc
    private func refreshData() {
        view.refresh()
    }
}

// MARK: - Extensions -

extension ScheduleScreenPresenter: ScheduleScreenPresenterInterface {
    var numberOfItems: Int {
        lessonsForChosenDay.count
    }

    func item(at indexPath: IndexPath) -> LessonModel {
        lessonsForChosenDay[indexPath.row]
    }

    func itemSelected(at indexPath: IndexPath) {
        print("Selected lesson with title \(lessonsForChosenDay[indexPath.row])")
    }

    func fetchLessons() {
        wireframe.showLoadingBar()
        attempt {
            try await self.interactor.getAllLessons()
        }.then { lessons in
            self.wireframe.hideLoadingBar()
            self.lessons = lessons
            self.updatePresentedLessons()
        }.catch { _ in
            self.wireframe.hideLoadingBar()
            self.updatePresentedLessons()
            self.wireframe.showAlert(title: "Error loading lessons", message: nil, preset: .error, presentSide: .top)
        }
    }

    func changeLesson(_ lesson: LessonModel) {
        wireframe.showLessonMaker(forLesson: lesson, courseId: lesson.courseId) { changed in
            if changed != nil {
                self.refreshData()
            }
        }
    }

    func setDate(_ date: Date) {
        selectedDate = date
        updatePresentedLessons()
    }

    private func updatePresentedLessons() {
        lessonsForChosenDay = lessons?.filter { lesson in
            lesson.startDateTime.get(.day) == selectedDate.get(.day) &&
                lesson.startDateTime.get(.month) == selectedDate.get(.month) &&
                lesson.startDateTime.get(.year) == selectedDate.get(.year)
        } ?? []
        lessonsForChosenDay.sort { $0.startDateTime < $1.startDateTime }
    }

    func removeLesson(atIndexPath indexPath: IndexPath) {
        attempt {
            try await self.interactor.removeLesson(self.lessonsForChosenDay[indexPath.row])
        }.then { _ in
            self.wireframe.showAlert(title: "Lesson removed", message: nil, preset: .error, presentSide: .top)
            self.refreshData()
        }.catch { _ in
            self.wireframe.showAlert(title: "Error deleting lesson", message: nil, preset: .error, presentSide: .top)
        }
    }
}
