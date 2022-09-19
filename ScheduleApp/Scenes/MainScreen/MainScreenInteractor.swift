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

final class LessonsService {
	func getLessons() async throws -> [LessonModel] {
//		let authstr = "admin:admin"
//		let auth = Data(authstr.utf8).base64EncodedString()
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601
		return try await AF.request(Constants.Network.baseUrl + "/lesson",
									headers: ["Authorization": "Basic YWRtaW46YWRtaW4="])
						   .serializingDecodable([LessonModel].self, decoder: decoder)
						   .value
	}
}
