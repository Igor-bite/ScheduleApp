//
//  ScheduleScreenPresenter.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 15.09.2022.
//

import AsyncPlus
import Foundation

public final class ScheduleScreenPresenter {
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
    public var numberOfItems: Int {
        lessonsForChosenDay.count
    }

    public func item(at indexPath: IndexPath) -> LessonModel {
        lessonsForChosenDay[indexPath.row]
    }

    public func itemSelected(at indexPath: IndexPath) {
        print("Selected lesson with title \(lessonsForChosenDay[indexPath.row])")
    }

    public func fetchLessons() {
        wireframe.showLoadingBar()
        attempt {
            try await self.interactor.getAllLessons()
        }.then { lessons in
            self.wireframe.hideLoadingBar()
            self.lessons = lessons
            self.updatePresentedLessons()
        }.catch { _ in
            self.wireframe.hideLoadingBar()
            self.wireframe.showAlert(title: "Error loading lessons", message: nil, preset: .error, presentSide: .top)
        }
    }

    public func setDate(_ date: Date) {
        selectedDate = date
        updatePresentedLessons()
    }

    private func updatePresentedLessons() {
        guard let lessons = lessons
        else { return }
        lessonsForChosenDay = lessons.filter { lesson in
            lesson.startDateTime.get(.day) == selectedDate.get(.day)
        }
    }
}
