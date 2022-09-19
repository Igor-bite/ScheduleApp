//
//  LessonsService.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 20.09.2022.
//

import Foundation
import Alamofire

final class LessonsService {
	func getLessons() async throws -> [LessonModel] {
		let authstr = "admin:admin"
		let auth = Data(authstr.utf8).base64EncodedString()
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601
		return try await AF.request(Constants.Network.baseUrl + "/lesson",
									headers: ["Authorization": "Basic \(auth)"])
						   .serializingDecodable([LessonModel].self, decoder: decoder)
						   .value
	}
}
