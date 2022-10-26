//
//  NetworkService.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 25.10.2022.
//  Copyright © 2022 messeb.com. All rights reserved.
//

import Foundation
import Moya

protocol NetworkServiceProtocol {
    func request(_ target: TargetType, completion: @escaping Moya.Completion)
    func request(_ target: TargetType) async throws -> Moya.Response
}

final class NetworkService: NetworkServiceProtocol {
    static let shared = NetworkService()

    private let provider: MoyaProvider<MultiTarget>

    private init() {
        let logger = NetworkLoggerPlugin(configuration: .init(logOptions: [.requestMethod, .successResponseBody, .errorResponseBody]))
        provider = .init(plugins: [logger])
    }

    func request(_ target: TargetType, completion: @escaping Moya.Completion) {
        provider.request(MultiTarget(target), completion: completion)
    }

    func request(_ target: TargetType) async throws -> Moya.Response {
        try await withCheckedThrowingContinuation { continuation in
            request(target) { result in
                continuation.resume(with: result)
            }
        }
    }
}
