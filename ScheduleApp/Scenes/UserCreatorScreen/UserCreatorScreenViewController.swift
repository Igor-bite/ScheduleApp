//
//  UserCreatorScreenViewController.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 01.11.2022.
//

import CocoaTextField
import SnapKit
import UIKit

final class UserCreatorScreenViewController: UIViewController {
    enum Constants {
        static let submitButtonHeight = 48
        static let gapHeight = 20
        static let sideOffset = 16
        static let sectionHeight = 44
        static let twoThirdsSections = sectionHeight / 3 * 2
    }

    private lazy var labelView: UILabel = {
        let view = UILabel.titleLabel
        view.text = "Новый пользователь"
        return view
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 14
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.backgroundColor = .Pallette.mainBgColor
        return view
    }()

    private lazy var secondNameInput = {
        let textField = CocoaTextField()
        textField.placeholder = "Фамилия"
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

    private lazy var firstNameInput = {
        let textField = CocoaTextField()
        textField.placeholder = "Имя"
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

    private lazy var lastNameInput = {
        let textField = CocoaTextField()
        textField.placeholder = "Отчество"
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

    private lazy var birthdayLabel = {
        let view = UILabel.titleLabel
        view.text = "Дата рождения:"
        return view
    }()

    private lazy var birthdayDatePicker = {
        let picker = UIDatePicker()
        picker.date = Date()
        picker.locale = .init(identifier: "ru_RU")
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        return picker
    }()

    private lazy var usernameInput = {
        let textField = CocoaTextField()
        textField.placeholder = "Юзернейм"
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

    private lazy var passwordInput = {
        let textField = CocoaTextField()
        textField.placeholder = "Пароль"
        textField.isSecureTextEntry = true
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
        button.addTarget(self, action: #selector(create), for: .touchUpInside)
        return button
    }()

    // MARK: - Public properties -

    // swiftlint:disable:next implicitly_unwrapped_optional
    var presenter: UserCreatorScreenPresenterInterface!

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()

        traceKeyboard()
        hideKeyboardOnTap()
        view.backgroundColor = .clear
        setupViews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        secondNameInput.becomeFirstResponder()
    }

    private func setupViews() {
        view.addSubview(contentView)
        contentView.addSubview(labelView)
        contentView.addSubview(secondNameInput)
        contentView.addSubview(firstNameInput)
        contentView.addSubview(lastNameInput)
        contentView.addSubview(birthdayLabel)
        contentView.addSubview(birthdayDatePicker)
        contentView.addSubview(usernameInput)
        contentView.addSubview(passwordInput)
        contentView.addSubview(submitButton)

        makeConstraints()
    }

    @objc
    private func create() {
        guard let secondName = secondNameInput.text?.nilIfEmpty else {
            secondNameInput.setError(errorString: "")
            return
        }

        guard let firstName = firstNameInput.text?.nilIfEmpty else {
            firstNameInput.setError(errorString: "")
            return
        }

        guard let lastName = lastNameInput.text?.nilIfEmpty else {
            lastNameInput.setError(errorString: "")
            return
        }

        guard let username = usernameInput.text?.nilIfEmpty else {
            usernameInput.setError(errorString: "")
            return
        }

        guard let pass = passwordInput.text?.nilIfEmpty else {
            passwordInput.setError(errorString: "")
            return
        }
        presenter.create(user: .init(username: username, password: pass, firstName: firstName,
                                     lastName: lastName, secondName: secondName, birthday: birthdayDatePicker.date))
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Extensions -

extension UserCreatorScreenViewController: UserCreatorScreenViewInterface {}

private extension UserCreatorScreenViewController {
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
            make.bottom.equalTo(secondNameInput.snp.top).offset(-Constants.gapHeight)
        }
        secondNameInput.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.sideOffset)
            make.trailing.equalToSuperview().inset(Constants.sideOffset)
            make.height.equalTo(Constants.sectionHeight)
            make.bottom.equalTo(firstNameInput.snp.top).offset(-Constants.gapHeight)
        }
        firstNameInput.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Constants.sideOffset)
            make.right.equalToSuperview().inset(Constants.sideOffset)
            make.height.equalTo(Constants.sectionHeight)
            make.bottom.equalTo(lastNameInput.snp.top).offset(-Constants.gapHeight)
        }
        lastNameInput.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.sideOffset)
            make.trailing.equalToSuperview().inset(Constants.sideOffset)
            make.height.equalTo(Constants.sectionHeight)
            make.bottom.equalTo(birthdayLabel.snp.top).offset(-Constants.gapHeight)
        }
        birthdayLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.sideOffset)
            make.height.equalTo(Constants.sectionHeight)
            make.bottom.equalTo(usernameInput.snp.top).offset(-Constants.gapHeight)
        }
        birthdayDatePicker.snp.makeConstraints { make in
            make.leading.equalTo(birthdayLabel.snp.trailing).offset(Constants.sideOffset / 2)
            make.trailing.equalToSuperview().inset(Constants.sideOffset)
            make.height.equalTo(Constants.sectionHeight)
            make.bottom.equalTo(usernameInput.snp.top).offset(-Constants.gapHeight)
        }
        usernameInput.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.sideOffset)
            make.trailing.equalToSuperview().inset(Constants.sideOffset)
            make.height.equalTo(Constants.sectionHeight)
            make.bottom.equalTo(passwordInput.snp.top).offset(-Constants.gapHeight)
        }
        passwordInput.snp.makeConstraints { make in
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
