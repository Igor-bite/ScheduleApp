//
//  Encodable + toDictionary.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 07.10.2022.
//  Copyright © 2022 messeb.com. All rights reserved.
//

import Foundation

extension Encodable {
    var asDictionary: [String: Any] {
        (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Any] ?? [:]
    }
}
