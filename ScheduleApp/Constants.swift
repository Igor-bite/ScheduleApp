//
//  Constants.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 16.09.2022.
//

import UIKit
import Lottie

enum Constants {
	enum Network {
		static let baseUrl = "https://tinkoff-course-work.herokuapp.com"
	}

    static let loadingBarHeight = 4.0
}

extension AnimationView {
	static let relaxAnimation = AnimationView(name: "relaxAnimation")
	static let activeIndicator = AnimationView(name: "activeIndicator")
	static let icon = AnimationView(name: "icon")
}
