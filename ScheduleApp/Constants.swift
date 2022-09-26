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
}

extension UIFont {
	static let title = roundedSystemFont(ofSize: 21, weight: .semibold)
	static let text = roundedSystemFont(ofSize: 16)
	static let secondaryText = roundedSystemFont(ofSize: 14)

	private static func roundedSystemFont(ofSize size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
		let systemFont = UIFont.systemFont(ofSize: size, weight: weight)
		let roundedFont: UIFont
		if let descriptor = systemFont.fontDescriptor.withDesign(.rounded) {
			roundedFont = UIFont(descriptor: descriptor, size: size)
		} else {
			roundedFont = systemFont
		}
		return roundedFont
	}
}

extension AnimationView {
	static let relaxAnimation = AnimationView(name: "relaxAnimation")
	static let activeIndicator = AnimationView(name: "activeIndicator")
	static let icon = AnimationView(name: "icon")
}

extension UIColor {
	static let grayColor = UIColor(white: 0, alpha: 0.07)
	static let blueColor = UIColor(red: 54 / 255, green: 134 / 255, blue: 247 / 255, alpha: 1)
}
