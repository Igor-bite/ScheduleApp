//
//  MainScreenInteractor.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 15.09.2022.
//

import Foundation
import Alamofire

public final class MainScreenInteractor {
	private let lessonsService = LessonsService()
}

// MARK: - Extensions -

extension MainScreenInteractor: MainScreenInteractorInterface {
	public func getAllLessons() async throws -> [LessonModel] {
		try await lessonsService.getLessons()
	}
}
