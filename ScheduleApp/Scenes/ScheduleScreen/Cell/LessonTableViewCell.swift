//
//  LessonTableViewCell.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 15.09.2022.
//

import Lottie
import Reusable
import SkeletonView
import UIKit

class LessonTableViewCell: UITableViewCell, Reusable {
    private enum Constants {
        static let offset = 20.0

        static let cellOffset = 15.0
        static let cellCornerRadius = 15.0
    }

    private let lessonTypeView = CapsuleView()

    private let lessonNameLabel = {
        let label = UILabel.titleLabel
        label.numberOfLines = 2
        return label
    }()

    private let teacherLabel = {
        let label = UILabel.textLabel
        label.textColor = .Pallette.secondaryTextColor
        return label
    }()

    private let lessonDescriptionLabel = UILabel.secondaryTextLabel

    private let timeLabel = {
        let label = UILabel.secondaryTextLabel
        label.textAlignment = .right
        return label
    }()

    private let activeIndicator = {
        let view = AnimationView.activeIndicator
        view.backgroundBehavior = .pauseAndRestore
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

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with lesson: LessonModel) {
        lessonNameLabel.text = lesson.title
        lessonDescriptionLabel.text = lesson.description
        lessonTypeView.configure(withText: lesson.lessonType.toText(),
                                 color: lesson.lessonType.bgColor())

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        timeLabel.text = "\(dateFormatter.string(from: lesson.startDateTime))-\(dateFormatter.string(from: lesson.endDateTime))"

        teacherLabel.text = "Скоринов Максим Юрьевич"

//        if Date().isBetweeen(date: lesson.startDateTime, andDate: lesson.endDateTime) {
//            activeIndicator.play()
//            activeIndicator.isHidden = false
//        } else {
//            activeIndicator.stop()
//            activeIndicator.isHidden = true
//        }
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
            make.top.equalTo(lessonTypeView.snp.bottom).offset(Constants.offset / 4)
            make.left.equalToSuperview().offset(Constants.offset)
            make.right.equalToSuperview().inset(Constants.offset)
        }

        teacherLabel.snp.makeConstraints { make in
            make.top.equalTo(lessonNameLabel.snp.bottom).offset(Constants.offset / 4)
            make.left.equalToSuperview().offset(Constants.offset)
            make.right.equalToSuperview().inset(Constants.offset)
        }

        lessonDescriptionLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(Constants.offset / 4)
            make.top.greaterThanOrEqualTo(teacherLabel.snp.bottom).offset(Constants.offset / 4)
            make.left.equalToSuperview().offset(Constants.offset)
            make.width.equalToSuperview().multipliedBy(0.7)
        }

        activeIndicator.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview().inset(7)
            make.width.height.equalTo(25)
        }
    }
}
