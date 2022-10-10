//
//  String+nilIfEmpty.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 10.10.2022.
//  Copyright © 2022 messeb.com. All rights reserved.
//

import Foundation

extension String {
    var nilIfEmpty: String? {
        if isEmpty {
            return nil
        }
        return self
    }
}
