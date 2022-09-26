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

	private var coursesToShow = [CourseModel]() {
		didSet {
			view.reloadData()
		}
	}
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
		return coursesToShow.count
	}
	
	public func item(at indexPath: IndexPath) -> CourseModel {
		coursesToShow[indexPath.row]
	}
	
	public func itemSelected(at indexPath: IndexPath) {
		print("Selected course at \(indexPath)")
	}
	
	public func fetchLessons() {
		attempt {
			try await self.interactor.getAllCourses()
		}.then { courses in
			self.courses = courses
			self.updatePresentedCourses()
		}.catch { error in
			self.wireframe.showAlert(title: "Error loading courses", message: nil, preset: .error, presentSide: .top)
		}
	}

	private func updatePresentedCourses() {
		guard let courses else { return }
		coursesToShow = courses
	}
}
