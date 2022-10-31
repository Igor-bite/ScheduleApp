//
//  LessonCreatorScreenViewController.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 28.10.2022.
//

import CocoaTextField
import SnapKit
import STTextView
import UIKit

final class LessonCreatorScreenViewController: UIViewController {
    enum Constants {
        static let submitButtonHeight = 48
        static let gapHeight = 20
        static let sideOffset = 16
        static let sectionHeight = 44
        static let twoThirdsSections = sectionHeight / 3 * 2
    }

    private lazy var labelView: UILabel = {
        let view = UILabel.titleLabel
        view.text = presenter.title
        return view
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 14
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.backgroundColor = .Pallette.mainBgColor
        return view
    }()

    private let lessonTypeSegmentedControl = {
        let control = UISegmentedControl(items: ["Лекция", "Практика", "Семинар"])
        control.selectedSegmentIndex = 0
        return control
    }()

    private var placeholderAttributes: [NSAttributedString.Key: Any] {
        [
            NSAttributedString.Key.foregroundColor: UIColor.Pallette.secondaryTextColor.withAlphaComponent(0.4),
            NSAttributedString.Key.font: UIFont.text
        ]
    }

    private lazy var titleEnterInput = {
        let textField = CocoaTextField()
        textField.placeholder = "Название урока"
        textField.inactiveHintColor = .Pallette.secondaryTextColor.withAlphaComponent(0.4)
        textField.activeHintColor = .Pallette.buttonBg
        textField.focusedBackgroundColor = .Pallette.mainBgColor
        textField.defaultBackgroundColor = .Pallette.mainBgColor
        textField.borderColor = .Pallette.buttonBg
        textField.errorColor = UIColor(red: 231 / 255, green: 76 / 255, blue: 60 / 255, alpha: 0.7)
        textField.borderWidth = 1
        textField.cornerRadius = 11
        return textField
    }()

    private lazy var descriptionEnterInput = {
        let textField = STTextView()
        let placeholder = "Описание урока"
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: placeholderAttributes)
        textField.font = .text
        textField.textContainerInset.left = 10
        textField.layer.cornerRadius = 11
        textField.layer.borderColor = UIColor.Pallette.buttonBg.lightThemeColor.cgColor
        textField.layer.borderWidth = 1
        return textField
    }()

    private lazy var startDateLabel = {
        let view = UILabel.titleLabel
        view.text = "Начало:"
        return view
    }()

    private lazy var endDateLabel = {
        let view = UILabel.titleLabel
        view.text = "Конец:"
        return view
    }()

    private lazy var startDateTimePicker = {
        let picker = UIDatePicker()
        picker.date = Date()
        picker.locale = .init(identifier: "ru_RU")
        picker.datePickerMode = .dateAndTime
        picker.preferredDatePickerStyle = .compact
        picker.addTarget(self, action: #selector(updateEndDateTime), for: .valueChanged)
        return picker
    }()

    private lazy var endDateTimePicker = {
        let picker = UIDatePicker()
        picker.date = Date().addingTimeInterval(60 * 60 * 1.5) // adding 1.5 h
        picker.locale = .init(identifier: "ru_RU")
        picker.datePickerMode = .dateAndTime
        picker.preferredDatePickerStyle = .compact
        return picker
    }()

    private lazy var submitButton: UIButton = {
        let button = UIButton.barButton
        button.setTitle("Создать", for: .normal)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(createCourse), for: .touchUpInside)
        return button
    }()

    // MARK: - properties -

    // swiftlint:disable:next implicitly_unwrapped_optional
    var presenter: LessonCreatorScreenPresenterInterface!

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()

        traceKeyboard()
        hideKeyboardOnTap()
        view.backgroundColor = .clear
        setupViews()
        updateText()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        titleEnterInput.becomeFirstResponder()
    }

    private func setupViews() {
        view.addSubview(contentView)
        contentView.addSubview(labelView)
        contentView.addSubview(lessonTypeSegmentedControl)
        contentView.addSubview(titleEnterInput)
        contentView.addSubview(descriptionEnterInput)
        contentView.addSubview(startDateLabel)
        contentView.addSubview(endDateLabel)
        contentView.addSubview(startDateTimePicker)
        contentView.addSubview(endDateTimePicker)
        contentView.addSubview(submitButton)

        makeConstraints()
    }

    @objc
    private func createCourse() {
        var type: LessonType?

        switch lessonTypeSegmentedControl.selectedSegmentIndex {
        case 0:
            type = .lecture
        case 1:
            type = .practice
        case 2:
            type = .seminar
        default:
            break
        }

        guard let type = type,
              let description = descriptionEnterInput.text
        else { return }

        guard let name = titleEnterInput.text?.nilIfEmpty
        else {
            titleEnterInput.setError(errorString: "Урок необходимо назвать")
            return
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        let start = formatter.string(from: startDateTimePicker.date)
        print(start)

        guard let curUserId = AuthService.shared.currentUser?.id else { return }
        presenter.commit(.init(title: name, description: description,
                               teacherId: curUserId, courseId: presenter.courseId,
                               startDateTime: startDateTimePicker.date,
                               endDateTime: endDateTimePicker.date, lessonType: type))
        dismiss(animated: true, completion: nil)
    }

    @objc
    private func updateEndDateTime() {
        endDateTimePicker.date = startDateTimePicker.date.addingTimeInterval(60 * 60 * 1.5)
    }

    private func updateText() {
        guard let lesson = presenter.lesson else { return }
        switch lesson.lessonType {
        case .lecture:
            lessonTypeSegmentedControl.selectedSegmentIndex = 0
        case .practice:
            lessonTypeSegmentedControl.selectedSegmentIndex = 1
        case .seminar:
            lessonTypeSegmentedControl.selectedSegmentIndex = 2
        }

        titleEnterInput.text = lesson.title
        descriptionEnterInput.text = lesson.description

        startDateTimePicker.date = lesson.startDateTime
        endDateTimePicker.date = lesson.endDateTime

        submitButton.setTitle("Изменить", for: .normal)
    }
}

// MARK: - Extensions -

extension LessonCreatorScreenViewController: LessonCreatorScreenViewInterface {}

private extension LessonCreatorScreenViewController {
    func makeContentViewConstraints() {
        contentView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(labelView.snp.top).offset(-Constants.gapHeight)
        }
    }

    func makeConstraints() {
        makeContentViewConstraints()
        labelView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.sideOffset)
            make.trailing.equalToSuperview().inset(Constants.sideOffset)
            make.height.equalTo(Constants.sectionHeight)
            make.bottom.equalTo(lessonTypeSegmentedControl.snp.top).offset(-Constants.gapHeight)
        }
        lessonTypeSegmentedControl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.sideOffset)
            make.trailing.equalToSuperview().inset(Constants.sideOffset)
            make.height.equalTo(Constants.twoThirdsSections)
            make.bottom.equalTo(titleEnterInput.snp.top).offset(-Constants.gapHeight)
        }
        titleEnterInput.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.sideOffset)
            make.trailing.equalToSuperview().inset(Constants.sideOffset)
            make.height.equalTo(Constants.sectionHeight)
            make.bottom.equalTo(descriptionEnterInput.snp.top).offset(-Constants.gapHeight)
        }
        descriptionEnterInput.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Constants.sideOffset)
            make.right.equalToSuperview().inset(Constants.sideOffset)
            make.height.equalTo(Constants.sectionHeight * 2)
            make.bottom.equalTo(startDateTimePicker.snp.top).offset(-Constants.gapHeight)
        }

        startDateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.sideOffset * 2)
            make.height.equalTo(Constants.sectionHeight)
            make.width.equalTo(UIScreen.main.bounds.width).multipliedBy(0.2)
            make.centerY.equalTo(startDateTimePicker)
        }

        startDateTimePicker.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(Constants.sideOffset)
            make.height.equalTo(Constants.sectionHeight)
            make.bottom.equalTo(endDateTimePicker.snp.top).offset(-Constants.gapHeight)
            make.width.equalTo(UIScreen.main.bounds.width).multipliedBy(0.6)
        }

        endDateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.sideOffset * 2)
            make.height.equalTo(Constants.sectionHeight)
            make.width.equalTo(UIScreen.main.bounds.width).multipliedBy(0.2)
            make.centerY.equalTo(endDateTimePicker)
        }

        endDateTimePicker.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(Constants.sideOffset)
            make.height.equalTo(Constants.sectionHeight)
            make.bottom.equalTo(submitButton.snp.top).offset(-Constants.gapHeight)
            make.width.equalTo(UIScreen.main.bounds.width).multipliedBy(0.6)
        }

        submitButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.sideOffset)
            make.trailing.equalToSuperview().inset(Constants.sideOffset)
            make.height.equalTo(Constants.sectionHeight)
            guard let safeAreaInsets = UIApplication.shared.windows.first?.safeAreaInsets else { return }
            make.bottom.equalTo(contentView.snp.bottom).inset(Constants.gapHeight + Int(safeAreaInsets.bottom))
        }
    }
}
