//
//  ScheduleScreenTests.swift
//  ScheduleAppTests
//
//  Created by Игорь Клюжев on 26.09.2022.
//

import XCTest
@testable import ScheduleApp
import AsyncPlus

final class ScheduleScreenTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

//	MARK: - Interactor

    func test_interactor_getAllLessons() throws {
		let lessonsService = MockedLessonsService()
        let sut = ScheduleScreenInteractor(lessonsService: lessonsService)

		attempt {
			try await sut.getAllLessons()
		}.then { lessons in
			XCTAssertTrue(lessons == MockedLessonsService.lessons)
		}.catch { _ in
			XCTFail("Should not fail with error")
		}
    }
}
