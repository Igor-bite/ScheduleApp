//
//  TargetType+Extension.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 25.10.2022.
//  Copyright © 2022 messeb.com. All rights reserved.
//

import Foundation
import Moya

// swiftlint:disable force_unwrapping
extension TargetType {
    var baseURL: URL {
        URL(string: Constants.Network.baseUrl)!
    }

    var headers: [String: String]? {
        if let authHeader = AuthService.shared.basicAuthHeader() {
            return ["Authorization": authHeader]
        }
        return nil
    }
}
