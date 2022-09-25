//
//  DateCell.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 25.09.2022.
//  Copyright © 2022 messeb.com. All rights reserved.
//

import UIKit
import JTAppleCalendar
import Reusable
import SnapKit

class DateCell: JTACDayCell, Reusable {
	private enum Constants {
		static let height = 75.0
		static let selectedColor = UIColor.blueColor
	}

	private let weekdayNameLabel = {
		let label = UILabel()
		label.font = .secondaryText
		label.textColor = .gray
		return label
	}()
	private let dayNumberLabel = {
		let label = UILabel()
		label.font = .title
		return label
	}()

	static let height = Constants.height

	var weekday: DaysOfWeek? {
		didSet {
			switch weekday {
			case .monday:
				weekdayNameLabel.text = "Пн"
			case .tuesday:
				weekdayNameLabel.text = "Вт"
			case .wednesday:
				weekdayNameLabel.text = "Ср"
			case .thursday:
				weekdayNameLabel.text = "Чт"
			case .friday:
				weekdayNameLabel.text = "Пт"
			case .saturday:
				weekdayNameLabel.text = "Сб"
			case .sunday:
				weekdayNameLabel.text = "Вс"
			case .none:
				break
			}
		}
	}

	var dayNumber: String {
		get {
			dayNumberLabel.text ?? ""
		}
		set {
			dayNumberLabel.text = newValue
		}
	}

	override var isSelected: Bool {
		didSet {
			toggleSelection()
		}
	}

	override init(frame: CGRect) {
		super.init(frame: frame)

		setupViews()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupViews() {
		layer.cornerRadius = 10
		backgroundColor = .grayColor

		addSubview(weekdayNameLabel)
		addSubview(dayNumberLabel)

		weekdayNameLabel.textAlignment = .center
		weekdayNameLabel.snp.makeConstraints { make in
			make.right.top.left.equalToSuperview()
			make.height.equalTo(Constants.height / 3)
		}

		dayNumberLabel.textAlignment = .center
		dayNumberLabel.snp.makeConstraints { make in
			make.right.bottom.left.equalToSuperview()
			make.height.equalTo(Constants.height * 2 / 3)
		}
	}

	func toggleSelection() {
		if isSelected {
			backgroundColor = Constants.selectedColor
			dayNumberLabel.textColor = .white
			weekdayNameLabel.textColor = .white
		} else {
			backgroundColor = .grayColor
			dayNumberLabel.textColor = .black
			weekdayNameLabel.textColor = .gray
		}
	}
}
