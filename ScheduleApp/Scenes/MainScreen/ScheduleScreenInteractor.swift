//
//  ScheduleScreenInteractor.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 15.09.2022.
//

import Foundation
import Alamofire

public final class ScheduleScreenInteractor {
	private let lessonsService = LessonsService()
}

// MARK: - Extensions -

extension ScheduleScreenInteractor: ScheduleScreenInteractorInterface {
	public func getAllLessons() async throws -> [LessonModel] {
		try await lessonsService.getLessons()
	}
}
