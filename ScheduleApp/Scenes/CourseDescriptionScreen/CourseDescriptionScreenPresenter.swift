//
//  CourseDescriptionScreenPresenter.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 25.10.2022.
//

import AsyncPlus
import Foundation

final class CourseDescriptionScreenPresenter {
    // MARK: - Private properties -

    private unowned let view: CourseDescriptionScreenViewInterface
    private let interactor: CourseDescriptionScreenInteractorInterface
    private let wireframe: CourseDescriptionScreenWireframeInterface

    var course: CourseModel {
        didSet {
            view.reloadCourseInfo()
        }
    }

    private var courseLessons: [LessonModel]? {
        didSet {
            view.reloadLessons()
        }
    }

    // MARK: - Lifecycle -

    init(
        view: CourseDescriptionScreenViewInterface,
        interactor: CourseDescriptionScreenInteractorInterface,
        wireframe: CourseDescriptionScreenWireframeInterface,
        course: CourseModel
    ) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
        self.course = course
    }
}

// MARK: - Extensions -

extension CourseDescriptionScreenPresenter: CourseDescriptionScreenPresenterInterface {
    var numberOfLessons: Int {
        courseLessons?.count ?? 0
    }

    func lesson(forIndexPath indexPath: IndexPath) -> LessonModel? {
        courseLessons?[indexPath.row]
    }

    func delete() {
        interactor.delete(course)
    }

    func clone() {
        interactor.clone(course)
    }

    func enroll() {
        interactor.enroll(course)
    }

    func leave() {
        interactor.leave(course)
    }

    func lessons() {
        attempt {
            try await self.interactor.lessons(self.course)
        }.then { lessons in
            self.courseLessons = lessons
        }.catch { error in
            print(error)
            self.wireframe.showAlert(title: "Error", message: nil, preset: .error, presentSide: .top)
        }
    }

    func change() {
        wireframe.showCourseChange()
    }

    func dismiss() {
        wireframe.goBack()
    }
}