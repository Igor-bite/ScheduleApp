//
//  Buttons.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 27.09.2022.
//

import UIKit

extension UIButton {
	static var barButton: UIButton {
		let button = UIButton()
		button.backgroundColor = .Pallette.buttonBg
		button.layer.cornerRadius = 7
		button.titleLabel?.font = .text
		button.titleLabel?.textColor = .Pallette.textColor.darkThemeColor
		return button
	}
}
