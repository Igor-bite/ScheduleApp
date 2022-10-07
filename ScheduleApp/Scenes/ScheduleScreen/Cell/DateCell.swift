//
//  DateCell.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 25.09.2022.
//

import UIKit
import JTAppleCalendar
import Reusable
import SnapKit

class DateCell: JTACDayCell, Reusable {
	private enum Constants {
		enum Selected {
			static let bgColor = UIColor.Pallette.buttonBg
			static let textColor = UIColor.Pallette.textColor.darkThemeColor
		}

		enum Today {
			static let dayNumberColor = UIColor.red
			static let dayNameColor = UIColor.Pallette.secondaryTextColor
		}

		enum Normal {
			static let bgColor = UIColor.Pallette.gray
			static let dayNumberColor = UIColor.Pallette.textColor
			static let dayNameColor = UIColor.Pallette.secondaryTextColor
		}

		static let cellHeight = 75.0
	}

	private let dayNameLabel = UILabel.secondaryTextLabel
	private let dayNumberLabel = UILabel.titleLabel

	static let height = Constants.cellHeight

	var weekday: DaysOfWeek? {
		didSet {
			switch weekday {
			case .monday:
				dayNameLabel.text = "Пн"
			case .tuesday:
				dayNameLabel.text = "Вт"
			case .wednesday:
				dayNameLabel.text = "Ср"
			case .thursday:
				dayNameLabel.text = "Чт"
			case .friday:
				dayNameLabel.text = "Пт"
			case .saturday:
				dayNameLabel.text = "Сб"
			case .sunday:
				dayNameLabel.text = "Вс"
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

	var isToday: Bool = false {
		didSet {
			updateColors()
		}
	}

	override var isSelected: Bool {
		didSet {
			updateColors()
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
		backgroundColor = .Pallette.gray

		addSubview(dayNameLabel)
		addSubview(dayNumberLabel)

		dayNameLabel.textAlignment = .center
		dayNameLabel.snp.makeConstraints { make in
			make.right.top.left.equalToSuperview()
			make.height.equalTo(Constants.cellHeight / 3)
		}

		dayNumberLabel.textAlignment = .center
		dayNumberLabel.snp.makeConstraints { make in
			make.right.bottom.left.equalToSuperview()
			make.height.equalTo(Constants.cellHeight * 2 / 3)
		}
	}

	func updateColors() {
		if isSelected {
			backgroundColor = Constants.Selected.bgColor
			dayNumberLabel.textColor = Constants.Selected.textColor
			dayNameLabel.textColor = Constants.Selected.textColor
		} else {
			backgroundColor = Constants.Normal.bgColor
			dayNumberLabel.textColor = isToday ? Constants.Today.dayNumberColor : Constants.Normal.dayNumberColor
			dayNameLabel.textColor = isToday ? Constants.Today.dayNameColor : Constants.Normal.dayNameColor
		}
	}
}
