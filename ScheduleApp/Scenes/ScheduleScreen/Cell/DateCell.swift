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
			static let bgColor = UIColor.blueColor
			static let textColor = UIColor.white
		}

		enum Today {
			static let dayNumberColor = UIColor.red
			static let dayNameColor = UIColor.gray
		}

		enum Normal {
			static let bgColor = UIColor.grayColor
			static let dayNumberColor = UIColor.black
			static let dayNameColor = UIColor.gray
		}

		static let cellHeight = 75.0
	}

	private let dayNameLabel = {
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
			if !isSelected {
				dayNumberLabel.textColor = isToday ? .red : .black
			}
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

	func toggleSelection() {
		if isSelected {
			backgroundColor = Constants.Selected.bgColor
			dayNumberLabel.textColor = .white
			dayNameLabel.textColor = .white
		} else {
			backgroundColor = Constants.Normal.bgColor
			dayNumberLabel.textColor = isToday ? Constants.Today.dayNumberColor : Constants.Normal.dayNumberColor
			dayNameLabel.textColor = isToday ? Constants.Today.dayNameColor : Constants.Normal.dayNameColor
		}
	}
}
