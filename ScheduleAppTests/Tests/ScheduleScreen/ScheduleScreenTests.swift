//
//  ScheduleScreenTests.swift
//  ScheduleAppTests
//
//  Created by Игорь Клюжев on 26.09.2022.
//

import AsyncPlus
@testable import ScheduleApp
import XCTest

final class ScheduleScreenTests: XCTestCase {
    // MARK: - Interactor

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
