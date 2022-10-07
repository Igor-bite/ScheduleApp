//
//  CoursesScreenPresenter.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 27.09.2022.
//

import Foundation
import AsyncPlus

public final class CoursesScreenPresenter {

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
	public var numberOfItems: Int {
		coursesToShow.count
	}

	public func item(at indexPath: IndexPath) -> CourseModel {
		coursesToShow[indexPath.row]
	}

	public func itemSelected(at indexPath: IndexPath) {
		print("Selected course at \(indexPath)")
	}

	public func fetchLessons() {
        self.wireframe.showLoadingBar()
		attempt {
			try await self.interactor.getAllCourses()
		}.then { courses in
            self.wireframe.hideLoadingBar()
			self.courses = courses
			self.updatePresentedCourses()
		}.catch { error in
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

	public func createNewCourse() {
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
}
