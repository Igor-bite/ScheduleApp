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
		static let baseUrl = "https://neoflex-practice.herokuapp.com"
	}
}

extension UIFont {
	static let title = UIFont.boldSystemFont(ofSize: 21)
	static let text = UIFont.systemFont(ofSize: 16)
	static let secondaryText = UIFont.systemFont(ofSize: 14)
}

extension AnimationView {
	static let relaxAnimation = AnimationView(name: "relaxAnimation")
}
