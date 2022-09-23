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
}
