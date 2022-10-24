//
//  CoursesCreatorScreenViewController.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 27.09.2022.
//

import CocoaTextField
import SnapKit
import STTextView
import UIKit

final class CoursesCreatorScreenViewController: UIViewController {
    enum Constants {
        static let submitButtonHeight = 48
        static let gapHeight = 20
        static let sideOffset = 16
        static let sectionHeight = 44
        static let twoThirdsSections = sectionHeight / 3 * 2
    }

    private let labelView: UILabel = {
        let view = UILabel.titleLabel
        view.text = "Новый курс"
        return view
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 14
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.backgroundColor = .Pallette.mainBgColor
        return view
    }()

    private let courseTypeSegmentedControl = UISegmentedControl(items: ["Оффлайн", "Онлайн"])

    private var placeholderAttributes: [NSAttributedString.Key: Any] {
        [
            NSAttributedString.Key.foregroundColor: UIColor.Pallette.secondaryTextColor.withAlphaComponent(0.4),
            NSAttributedString.Key.font: UIFont.text
        ]
    }

    private lazy var titleEnterInput = {
        let textField = CocoaTextField()
        textField.placeholder = "Название курса"
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
        let placeholder = "Описание курса"
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: placeholderAttributes)
        textField.font = .text
        textField.textContainerInset.left = 10
        textField.layer.cornerRadius = 11
        textField.layer.borderColor = UIColor.Pallette.buttonBg.lightThemeColor.cgColor
        textField.layer.borderWidth = 1
        return textField
    }()

    private lazy var customEnterInput1 = {
        let textField = CocoaTextField()
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

    private lazy var customEnterInput2 = {
        let textField = CocoaTextField()
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

    private lazy var submitButton: UIButton = {
        let button = UIButton.barButton
        button.setTitle("Создать", for: .normal)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(createCourse), for: .touchUpInside)
        return button
    }()

    private var bottomOfflineConstraint: Constraint?
    private var bottomOnlineConstraint: Constraint?

    // MARK: - Public properties -

    // swiftlint:disable:next implicitly_unwrapped_optional
    var presenter: CoursesCreatorScreenPresenterInterface!

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()

        traceKeyboard()
        hideKeyboardOnTap()
        view.backgroundColor = .clear
        setupViews()
        addSegementedControlAction()
        updateEnterInputVisibility()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        titleEnterInput.becomeFirstResponder()
    }

    private func setupViews() {
        view.addSubview(contentView)
        contentView.addSubview(labelView)
        contentView.addSubview(courseTypeSegmentedControl)
        contentView.addSubview(titleEnterInput)
        contentView.addSubview(descriptionEnterInput)
        contentView.addSubview(submitButton)
        contentView.addSubview(customEnterInput1)
        contentView.addSubview(customEnterInput2)

        makeConstraints()
    }

    private func addSegementedControlAction() {
        courseTypeSegmentedControl.selectedSegmentIndex = 0
        courseTypeSegmentedControl.addTarget(self, action: #selector(segmentedValueChanged), for: .valueChanged)
    }

    private func updateEnterInputVisibility() {
        switch courseTypeSegmentedControl.selectedSegmentIndex {
        case 0:
            bottomOfflineConstraint?.isActive = true
            bottomOnlineConstraint?.isActive = false
            UIView.animate(withDuration: 0.5) {
                self.customEnterInput1.placeholder = "Название университета"
                self.customEnterInput2.placeholder = "Адрес корпуса"
                self.customEnterInput1.text = ""
                self.customEnterInput2.text = ""
                self.customEnterInput2.alpha = 1
                self.view.layoutIfNeeded()
            }
        case 1:
            bottomOfflineConstraint?.isActive = false
            bottomOnlineConstraint?.isActive = true
            UIView.animate(withDuration: 0.5) {
                self.customEnterInput1.placeholder = "Ссылка на платформу с уроками"
                self.customEnterInput1.text = ""
                self.customEnterInput2.text = ""
                self.customEnterInput2.alpha = 0
                self.view.layoutIfNeeded()
            }
        default:
            break
        }
    }

    @objc
    func segmentedValueChanged() {
        updateEnterInputVisibility()
    }

    @objc
    private func createCourse() {
        let custom1 = customEnterInput1.text?.nilIfEmpty
        let custom2 = customEnterInput2.text?.nilIfEmpty
        var type: CourseModel.CourseType?

        switch courseTypeSegmentedControl.selectedSegmentIndex {
        case 0:
            type = .offline(.init(type: CourseModel.CourseType.OfflineCourseType.typeName, universityName: custom1, address: custom2))
        case 1:
            type = .online(.init(type: CourseModel.CourseType.OnlineCourseType.typeName, lessonUrl: custom1))
        default:
            break
        }

        guard let type = type,
              let description = descriptionEnterInput.text
        else { return }

        guard let name = titleEnterInput.text
        else {
            titleEnterInput.setError(errorString: "Курс необходимо назвать")
            return
        }

        presenter.createCourse(.init(title: name, description: description, categoryId: 0, curatorId: 0, type: type))
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Extensions -

extension CoursesCreatorScreenViewController: CoursesCreatorScreenViewInterface {}

private extension CoursesCreatorScreenViewController {
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
            make.bottom.equalTo(courseTypeSegmentedControl.snp.top).offset(-Constants.gapHeight)
        }
        courseTypeSegmentedControl.snp.makeConstraints { make in
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
            make.bottom.equalTo(customEnterInput1.snp.top).offset(-Constants.gapHeight)
        }
        customEnterInput1.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.sideOffset)
            make.trailing.equalToSuperview().inset(Constants.sideOffset)
            make.height.equalTo(Constants.sectionHeight)
            self.bottomOfflineConstraint = make.bottom.equalTo(customEnterInput2.snp.top).offset(-Constants.gapHeight).constraint
            self.bottomOnlineConstraint = make.bottom.equalTo(submitButton.snp.top).offset(-Constants.gapHeight).constraint
        }
        customEnterInput2.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.sideOffset)
            make.trailing.equalToSuperview().inset(Constants.sideOffset)
            make.height.equalTo(Constants.sectionHeight)
            make.bottom.equalTo(submitButton.snp.top).offset(-Constants.gapHeight)
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
