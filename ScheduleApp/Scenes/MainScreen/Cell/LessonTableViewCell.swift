//
//  LessonTableViewCell.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 15.09.2022.
//

import UIKit
import Reusable
import SkeletonView
import Lottie

class LessonTableViewCell: UITableViewCell, Reusable {
	private enum Constants {
		static let offset = 20.0

		static let cellOffset = 15.0
		static let cellCornerRadius = 15.0
	}

	private let lessonTypeView = LessonTypeCapsuleView()

	private let lessonNameLabel = {
		let label = UILabel()
		label.font = .title
		return label
	}()

	private let teacherLabel = {
		let label = UILabel()
		label.textColor = .gray
		label.font = .text
		return label
	}()

	private let lessonDescriptionLabel = {
		let label = UILabel()
		label.textColor = .gray
		label.font = .secondaryText
		return label
	}()

	private let timeLabel = {
		let label = UILabel()
		label.textAlignment = .right
		label.textColor = .gray
		label.font = .secondaryText
		return label
	}()

	private let activeIndicator = {
		let view = AnimationView.activeIndicator
		view.contentMode = .scaleAspectFit
		view.loopMode = .loop
		view.animationSpeed = 0.5
		view.isHidden = true
		return view
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		selectionStyle = .none
		setupViews()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func configure(with lesson: LessonModel) {
		lessonNameLabel.text = lesson.title
		lessonDescriptionLabel.text = lesson.description
		lessonTypeView.configure(with: .lection)

		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "HH:mm"
		timeLabel.text = "\(dateFormatter.string(from: lesson.startDateTime))-\(dateFormatter.string(from: lesson.endDateTime))"

		teacherLabel.text = "Акимова Арина Николаевна"
//		teacherLabel.isSkeletonable = true
//		teacherLabel.showAnimatedGradientSkeleton()
//		teacherLabel.startSkeletonAnimation()

		if Date().isBetweeen(date: lesson.startDateTime, andDate: lesson.endDateTime) {
			activeIndicator.play()
			activeIndicator.isHidden = false
		} else {
			activeIndicator.stop()
			activeIndicator.isHidden = true
		}
	}

	func setupViews() {
		let containerView = UIView()
		contentView.addSubview(containerView)
		containerView.snp.makeConstraints { make in
			make.left.equalToSuperview().offset(Constants.cellOffset)
			make.right.equalToSuperview().inset(Constants.cellOffset)
			make.top.equalToSuperview().offset(Constants.cellOffset / 2)
			make.bottom.equalToSuperview().inset(Constants.cellOffset / 2)
		}
		containerView.layer.cornerRadius = Constants.cellCornerRadius
		containerView.layer.masksToBounds = true
		containerView.backgroundColor = .init(white: 0, alpha: 0.07)

		containerView.addSubview(lessonTypeView)
		containerView.addSubview(lessonNameLabel)
		containerView.addSubview(teacherLabel)
		containerView.addSubview(lessonDescriptionLabel)
		containerView.addSubview(timeLabel)
		containerView.addSubview(activeIndicator)

		lessonTypeView.snp.makeConstraints { make in
			make.left.top.equalToSuperview().offset(Constants.offset)
			make.right.lessThanOrEqualTo(timeLabel.snp.left).inset(Constants.offset)
		}

		timeLabel.snp.makeConstraints { make in
			make.right.top.equalToSuperview().inset(Constants.offset)
			make.width.equalToSuperview().multipliedBy(0.3)
		}

		lessonNameLabel.snp.makeConstraints { make in
			make.top.equalTo(lessonTypeView.snp.bottom).offset(5)
			make.left.equalToSuperview().offset(Constants.offset)
			make.right.equalToSuperview().inset(Constants.offset)
		}

		teacherLabel.snp.makeConstraints { make in
			make.top.equalTo(lessonNameLabel.snp.bottom).offset(10)
			make.left.equalToSuperview().offset(Constants.offset)
			make.right.equalToSuperview().inset(Constants.offset)
		}

		lessonDescriptionLabel.snp.makeConstraints { make in
			make.bottom.equalToSuperview().inset(10)
			make.top.greaterThanOrEqualTo(teacherLabel.snp.bottom).offset(10)
			make.left.equalToSuperview().offset(Constants.offset)
			make.width.equalToSuperview().multipliedBy(0.7)
		}

		activeIndicator.snp.makeConstraints { make in
			make.right.bottom.equalToSuperview().inset(7)
			make.width.height.equalTo(25)
		}
	}
}
