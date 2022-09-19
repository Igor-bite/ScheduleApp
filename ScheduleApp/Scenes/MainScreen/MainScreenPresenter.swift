//
//  MainScreenPresenter.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 15.09.2022.
//

import Foundation
import AsyncPlus

public final class MainScreenPresenter {

	// MARK: - Private properties -

	private unowned let view: MainScreenViewInterface
	private let formatter: MainScreenFormatterInterface
	private let interactor: MainScreenInteractorInterface
	private let wireframe: MainScreenWireframeInterface

	private var lessons = [LessonModel]() {
		didSet {
			view.reloadData()
		}
	}

	// MARK: - Lifecycle -

	init(
		view: MainScreenViewInterface,
		formatter: MainScreenFormatterInterface,
		interactor: MainScreenInteractorInterface,
		wireframe: MainScreenWireframeInterface
	) {
		self.view = view
		self.formatter = formatter
		self.interactor = interactor
		self.wireframe = wireframe
	}
}

// MARK: - Extensions -

extension MainScreenPresenter: MainScreenPresenterInterface {
	public var numberOfItems: Int {
		lessons.count
	}

	public func item(at indexPath: IndexPath) -> LessonModel {
		lessons[indexPath.row]
	}

	public func itemSelected(at indexPath: IndexPath) {
		print("Selected lesson with title \(lessons[indexPath.row])")
	}

	public func loadLessons() {
		attempt {
			try await self.interactor.getAllLessons()
		}.then { lessons in
			self.lessons = lessons
		}.catch { _ in
			self.wireframe.showAlert(title: "Error loading lessons", message: nil, preset: .error, presentSide: .top)
		}
	}
}
