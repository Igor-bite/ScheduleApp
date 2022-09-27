//
//  CourseTableViewCell.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 27.09.2022.
//

import UIKit
import Reusable
import SkeletonView
import Lottie

class CourseTableViewCell: UITableViewCell, Reusable {
	private enum Constants {
		static let offset = 20.0

		static let cellOffset = 15.0
		static let cellCornerRadius = 15.0
	}

	private let courseTypeView = CapsuleLabelView()
	private let courseNameLabel = UILabel.titleLabel
	private let courseDescriptionLabel = UILabel.secondaryTextLabel
	private let vacantPlaceCountLabel = {
		let label = UILabel.secondaryTextLabel
		label.textAlignment = .right
		return label
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		selectionStyle = .none
		setupViews()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func configure(with course: CourseModel) {
		courseNameLabel.text = course.title
		courseDescriptionLabel.text = course.description
		courseTypeView.configure(withText: course.courseType.type.toText(), color: .init(light: .Pallette.lightBlue, dark: .Pallette.blue))
		vacantPlaceCountLabel.text = "\(course.studentCount)/\(course.studentCount)"
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
		containerView.backgroundColor = .Pallette.cellBgColor

		containerView.addSubview(courseTypeView)
		containerView.addSubview(courseNameLabel)
		containerView.addSubview(courseDescriptionLabel)
		containerView.addSubview(vacantPlaceCountLabel)

		courseTypeView.snp.makeConstraints { make in
			make.left.top.equalToSuperview().offset(Constants.offset)
			make.right.lessThanOrEqualTo(vacantPlaceCountLabel.snp.left).inset(Constants.offset)
		}

		vacantPlaceCountLabel.snp.makeConstraints { make in
			make.right.top.equalToSuperview().inset(Constants.offset)
			make.width.equalToSuperview().multipliedBy(0.3)
		}

		courseNameLabel.snp.makeConstraints { make in
			make.top.equalTo(courseTypeView.snp.bottom).offset(20)
			make.left.equalToSuperview().offset(Constants.offset)
			make.right.equalToSuperview().inset(Constants.offset)
		}

		courseDescriptionLabel.snp.makeConstraints { make in
			make.bottom.equalToSuperview().inset(10)
			make.top.greaterThanOrEqualTo(courseNameLabel.snp.bottom).offset(10)
			make.left.equalToSuperview().offset(Constants.offset)
			make.width.equalToSuperview().multipliedBy(0.7)
		}
	}
}
