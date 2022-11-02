//
//  LessonTableViewCell.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 15.09.2022.
//

import Lottie
import Reusable
import SafeSFSymbols
import SkeletonView
import UIKit

class LessonTableViewCell: UITableViewCell, Reusable {
    private enum Constants {
        static let offset = 15.0

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

    private let alarmImage = UIImage(.alarm).withTintColor(.white, renderingMode: .alwaysTemplate)

    private let pencilImage = UIImage(.pencil).withTintColor(.white, renderingMode: .alwaysTemplate)

    private lazy var actionButton = {
        let button = UIButton()
        let isNotificationSet = UserDefaults.standard.bool(forKey: notificationId ?? "")
        button.backgroundColor = isNotificationSet ? .Pallette.green : .Pallette.buttonBg
        button.setImage(self.alarmImage, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()

    private var changeLessonAction: (() -> Void)?
    private var lesson: LessonModel?

    private var notificationId: String? {
        guard let lesson = lesson else { return nil }
        return "Notify for lesson \(lesson.id)"
    }

    private var isNotificationSet = false

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func actionButtonTapped() {
        if let changeLessonAction = changeLessonAction {
            changeLessonAction()
        } else {
            isNotificationSet.toggle()
            handleNotification(isAdded: isNotificationSet)
            actionButton.backgroundColor = isNotificationSet ? .Pallette.green : .Pallette.buttonBg
        }
    }

    func configure(with lesson: LessonModel, shouldShowDate: Bool = false, changeLessonAction: @escaping () -> Void) {
        self.lesson = lesson
        isNotificationSet = notificationId == nil ? false : UserDefaults.standard.bool(forKey: notificationId ?? "")
        let curUser = AuthService.shared.currentUser
        if (curUser?.isAdmin ?? false) || lesson.teacherId == curUser?.id {
            self.changeLessonAction = changeLessonAction
            actionButton.setImage(pencilImage, for: .normal)
            actionButton.backgroundColor = .systemOrange
        } else {
            if lesson.startDateTime < Date().addingTimeInterval(5 * 60) {
                actionButton.isHidden = true
            } else {
                actionButton.isHidden = false
            }
            actionButton.setImage(alarmImage, for: .normal)
            actionButton.backgroundColor = isNotificationSet ? .Pallette.green : .Pallette.buttonBg
        }

        lessonNameLabel.text = lesson.title
        lessonDescriptionLabel.text = lesson.description
        lessonTypeView.configure(withText: lesson.lessonType.toText(),
                                 color: lesson.lessonType.bgColor())

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy HH:mm"

        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        if shouldShowDate {
            timeLabel.text = "\(dateFormatter.string(from: lesson.startDateTime))-\(timeFormatter.string(from: lesson.endDateTime))"
        } else {
            timeLabel.text = "\(timeFormatter.string(from: lesson.startDateTime))-\(timeFormatter.string(from: lesson.endDateTime))"
        }

        let teacher = lesson.teacher
        teacherLabel.text = "\(teacher.secondName) \(teacher.firstName) \(teacher.lastName)"
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
        containerView.addSubview(actionButton)

        lessonTypeView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(Constants.offset)
            make.right.lessThanOrEqualTo(timeLabel.snp.left).inset(Constants.offset)
        }

        timeLabel.snp.makeConstraints { make in
            make.right.top.equalToSuperview().inset(Constants.offset)
            make.left.equalTo(lessonTypeView.snp.right).offset(Constants.offset)
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

        actionButton.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview().inset(7)
            make.width.height.equalTo(30)
        }
    }

    private func handleNotification(isAdded: Bool) {
        let manager = NotificationManager.shared
        guard let notificationId = notificationId,
              let lesson = lesson
        else { return }
        if isAdded {
            let date = lesson.startDateTime.addingTimeInterval(-5 * 60)
            guard date > Date() else { return }
            let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            manager.addNotification(id: notificationId,
                                    title: "⏰ \(lesson.lessonType.toText()) уже скоро!",
                                    subtitle: lesson.title, trigger: trigger)
            UserDefaults.standard.set(true, forKey: notificationId)
        } else {
            UserDefaults.standard.set(false, forKey: notificationId)
            manager.removeNotifications([notificationId])
        }
    }
}
