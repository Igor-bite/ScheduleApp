//
//  CoursesScreenPresenter.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 27.09.2022.
//

import AsyncPlus
import Foundation

final class CoursesScreenPresenter {
    // MARK: - Private properties -

    private unowned let view: CoursesScreenViewInterface
    private let interactor: CoursesScreenInteractorInterface
    private let wireframe: CoursesScreenWireframeInterface

    private var coursesToShow = [CourseModel]()
    private var courses: [CourseModel]?

    // MARK: - Lifecycle -

    init(
        view: CoursesScreenViewInterface,
        interactor: CoursesScreenInteractorInterface,
        wireframe: CoursesScreenWireframeInterface
    ) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

// MARK: - Extensions -

extension CoursesScreenPresenter: CoursesScreenPresenterInterface {
    var numberOfItems: Int {
        coursesToShow.count
    }

    func item(at indexPath: IndexPath) -> CourseModel {
        coursesToShow[indexPath.row]
    }

    func itemSelected(at indexPath: IndexPath) {
        let course = coursesToShow[indexPath.row]
        wireframe.presentCourseDescription(course: course)
    }

    func fetchCourses() {
        wireframe.showLoadingBar()
        attempt {
            try await self.interactor.getAllCourses()
        }.then { courses in
            (courses, try await self.interactor.getEnrolledCourses())
        }.then { allCourses, enrolledCourses in
            var resultingCourses = allCourses
            allCourses.enumerated().forEach { index, course in
                if enrolledCourses.contains(where: { $0 == course }) {
                    resultingCourses[index].isEnrolled = true
                }
            }
            self.wireframe.hideLoadingBar()
            self.courses = resultingCourses
            self.updatePresentedCourses()
        }.catch { _ in
            self.wireframe.hideLoadingBar()
            self.wireframe.showAlert(title: "Error loading courses", message: nil, preset: .error, presentSide: .top)
        }
    }

    private func updatePresentedCourses() {
        guard let courses else { return }
        coursesToShow = courses.filter { course in
            switch course.type {
            case .base:
                return false
            default:
                return true
            }
        }
        view.reloadData()
    }

    func createNewCourse() {
        wireframe.presentCourseCreator { course in
            if let course = course {
                self.coursesToShow.append(course)
                self.view.insertNewCourse(at: .init(row: self.coursesToShow.count - 1, section: 0))
                self.wireframe.showAlert(title: "Added new course", message: nil, preset: .done, presentSide: .top)
            } else {
                self.wireframe.showAlert(title: "Error adding new course", message: "Please, try again", preset: .error, presentSide: .top)
            }
        }
    }

    func enrollOnCourse(at indexPath: IndexPath) {
        interactor.enrollOnCourse(coursesToShow[indexPath.row])
    }

    func leaveCourse(at indexPath: IndexPath) {
        interactor.leaveCourse(coursesToShow[indexPath.row])
    }

    func removeCourse(atIndexPath indexPath: IndexPath) {
        attempt {
            try await self.interactor.removeCourse(self.coursesToShow[indexPath.row])
        }.then { _ in
            self.wireframe.showAlert(title: "Removed course", message: nil, preset: .done, presentSide: .top)
            self.fetchCourses()
        }.catch { _ in
            self.wireframe.showAlert(title: "Error removing course", message: "Please, try again", preset: .error, presentSide: .top)
        }
    }
}
