//
//  MainScreenTableViewCell.swift
//  Core
//
//  Created by Игорь Клюжев on 15.09.2022.
//  Copyright © 2022 messeb.com. All rights reserved.
//

import Foundation
import Reusable

class MainScreenTableViewCell: UITableViewCell, Reusable {
	func configure(with lesson: LessonModel) {
		let text = lesson.title
		if #available(iOS 14.0, *) {
			var content = defaultContentConfiguration()
			content.text = text
			contentConfiguration = content
		} else {
			textLabel?.text = text
		}
	}
}
