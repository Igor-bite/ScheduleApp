//
//  AuthScreenViewController.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 24.10.2022.
//

import CocoaTextField
import SnapKit
import UIKit

final class AuthScreenViewController: UIViewController {
    private enum State {
        case signIn
        case signUp

        mutating func toggle() {
            switch self {
            case .signIn:
                self = .signUp
            case .signUp:
                self = .signIn
            }
        }
    }

    private var state = State.signIn {
        didSet {
            update()
        }
    }

    private let titleLabel = {
        let label = UILabel.titleLabel
        label.text = "Попробуй войти"
        return label
    }()

    private lazy var iconView = {
        let image = UIImageView(image: Asset.icon.image)
        image.contentMode = .scaleAspectFit
        return image
    }()

    private lazy var firstNameInput = {
        let textField = CocoaTextField()
        textField.placeholder = "Ваше имя"
        textField.inactiveHintColor = .Pallette.secondaryTextColor.withAlphaComponent(0.4)
        textField.activeHintColor = .Pallette.buttonBg
        textField.focusedBackgroundColor = .Pallette.mainBgColor
        textField.defaultBackgroundColor = .Pallette.mainBgColor
        textField.borderColor = .Pallette.buttonBg
        textField.errorColor = UIColor(red: 231 / 255, green: 76 / 255, blue: 60 / 255, alpha: 0.7)
        textField.borderWidth = 1
        textField.cornerRadius = 11
        textField.alpha = state == .signIn ? 0 : 1
        return textField
    }()

    private lazy var secondNameInput = {
        let textField = CocoaTextField()
        textField.placeholder = "Ваша фамилия"
        textField.inactiveHintColor = .Pallette.secondaryTextColor.withAlphaComponent(0.4)
        textField.activeHintColor = .Pallette.buttonBg
        textField.focusedBackgroundColor = .Pallette.mainBgColor
        textField.defaultBackgroundColor = .Pallette.mainBgColor
        textField.borderColor = .Pallette.buttonBg
        textField.errorColor = UIColor(red: 231 / 255, green: 76 / 255, blue: 60 / 255, alpha: 0.7)
        textField.borderWidth = 1
        textField.cornerRadius = 11
        textField.alpha = state == .signIn ? 0 : 1
        return textField
    }()

    private lazy var lastNameInput = {
        let textField = CocoaTextField()
        textField.placeholder = "Ваше отчество"
        textField.inactiveHintColor = .Pallette.secondaryTextColor.withAlphaComponent(0.4)
        textField.activeHintColor = .Pallette.buttonBg
        textField.focusedBackgroundColor = .Pallette.mainBgColor
        textField.defaultBackgroundColor = .Pallette.mainBgColor
        textField.borderColor = .Pallette.buttonBg
        textField.errorColor = UIColor(red: 231 / 255, green: 76 / 255, blue: 60 / 255, alpha: 0.7)
        textField.borderWidth = 1
        textField.cornerRadius = 11
        textField.alpha = state == .signIn ? 0 : 1
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

    private lazy var activeButton: UIButton = {
        let button = UIButton.barButton
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(activeButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var helperButton: UIButton = {
        let button = UIButton.barButton
        button.backgroundColor = .clear
        button.setTitleColor(.Pallette.buttonBg, for: .normal)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(helperButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Public properties -

    // swiftlint:disable:next implicitly_unwrapped_optional
    var presenter: AuthScreenPresenterInterface!

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .Pallette.mainBgColor

        setupViews()
        update(animated: false)
        birthdayDatePicker.date = .init()
    }

    private var signInConstraint: Constraint?
    private var signUpConstraint: Constraint?

    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(iconView)
        view.addSubview(firstNameInput)
        view.addSubview(secondNameInput)
        view.addSubview(lastNameInput)
        view.addSubview(birthdayLabel)
        view.addSubview(birthdayDatePicker)
        view.addSubview(usernameInput)
        view.addSubview(passwordInput)
        view.addSubview(activeButton)
        view.addSubview(helperButton)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.right.equalToSuperview().inset(20)
            make.height.equalTo(40)
            make.left.equalTo(iconView.snp.right).offset(10)
        }
        iconView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(40)
            make.width.equalToSuperview().multipliedBy(0.2)
            make.height.equalTo(iconView.snp.width)
        }
        firstNameInput.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
        secondNameInput.snp.makeConstraints { make in
            make.top.equalTo(firstNameInput.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
        lastNameInput.snp.makeConstraints { make in
            make.top.equalTo(secondNameInput.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
        birthdayLabel.snp.makeConstraints { make in
            make.leading.equalTo(lastNameInput.snp.leading)
            make.top.equalTo(lastNameInput.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
        birthdayDatePicker.snp.makeConstraints { make in
            make.trailing.equalTo(lastNameInput.snp.trailing)
            make.height.equalTo(40)
            make.top.equalTo(lastNameInput.snp.bottom).offset(10)
            make.leading.equalTo(birthdayLabel.snp.trailing).offset(10)
        }
        usernameInput.snp.makeConstraints { make in
            self.signUpConstraint = make.top.equalTo(birthdayLabel.snp.bottom).offset(10).constraint
            self.signInConstraint = make.top.equalTo(titleLabel.snp.bottom).offset(40).constraint
            self.signUpConstraint?.isActive = false
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
        passwordInput.snp.makeConstraints { make in
            make.top.equalTo(usernameInput.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
        activeButton.snp.makeConstraints { make in
            make.top.equalTo(passwordInput.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
        helperButton.snp.makeConstraints { make in
            make.top.equalTo(activeButton.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
    }

    @objc
    private func activeButtonTapped() {
        switch state {
        case .signIn:
            signIn()
        case .signUp:
            signUp()
        }
    }

    @objc
    private func helperButtonTapped() {
        state.toggle()
    }

    private func updateButtonTitles(animated: Bool = true) {
        switch state {
        case .signIn:
            activeButton.setTitle("Войти", for: .normal)
            helperButton.setTitle("Зарегистрироваться", for: .normal)
        case .signUp:
            activeButton.setTitle("Зарегистрироваться", for: .normal)
            helperButton.setTitle("Войти", for: .normal)
        }
        UIView.animate(withDuration: animated ? 0.5 : 0, delay: 0) {
            self.view.layoutIfNeeded()
        }
    }

    private func updateInputVisibility(animated: Bool = true, delay: TimeInterval = 0.0) {
        UIView.animate(withDuration: animated ? 0.5 : 0, delay: delay) {
            switch self.state {
            case .signUp:
                self.firstNameInput.alpha = 1.0
                self.secondNameInput.alpha = 1.0
                self.lastNameInput.alpha = 1.0
                self.birthdayLabel.alpha = 1.0
                self.birthdayDatePicker.alpha = 1.0
            case .signIn:
                self.firstNameInput.alpha = 0
                self.secondNameInput.alpha = 0
                self.lastNameInput.alpha = 0
                self.birthdayLabel.alpha = 0
                self.birthdayDatePicker.alpha = 0
            }
        }
    }

    private func updateConstraints(animated: Bool = true, delay: TimeInterval = 0.0) {
        switch state {
        case .signUp:
            signInConstraint?.isActive = false
            signUpConstraint?.isActive = true
        case .signIn:
            signInConstraint?.isActive = true
            signUpConstraint?.isActive = false
        }
        UIView.animate(withDuration: animated ? 0.5 : 0, delay: delay) {
            self.view.layoutIfNeeded()
        }
    }

    private func update(animated: Bool = true) {
        updateButtonTitles(animated: false)
        updateInputVisibility(animated: animated, delay: state == .signIn ? 0 : 0.3)
        updateConstraints(animated: animated, delay: state == .signIn ? 0.3 : 0)
    }

    private func signUp() {
        guard let firstName = firstNameInput.text,
              !firstName.isEmpty
        else {
            firstNameInput.setError(errorString: "")
            return
        }
        guard let secondName = secondNameInput.text,
              !secondName.isEmpty
        else {
            secondNameInput.setError(errorString: "")
            return
        }
        guard let lastName = lastNameInput.text,
              !lastName.isEmpty
        else {
            lastNameInput.setError(errorString: "")
            return
        }
        guard let username = usernameInput.text,
              !username.isEmpty
        else {
            usernameInput.setError(errorString: "")
            return
        }
        guard let password = passwordInput.text,
              password.count > 3
        else {
            passwordInput.setError(errorString: "")
            return
        }

        let user = CreateUserModel(username: username, password: password, firstName: firstName,
                                   lastName: lastName, secondName: secondName, birthday: birthdayDatePicker.date)

        presenter.signUp(user)
    }

    private func signIn() {
        guard let username = usernameInput.text,
              !username.isEmpty
        else {
            usernameInput.setError(errorString: "")
            return
        }
        guard let password = passwordInput.text,
              !password.isEmpty
        else {
            passwordInput.setError(errorString: "")
            return
        }

        presenter.signIn(withUsername: username, password: password)
    }
}

// MARK: - Extensions -

extension AuthScreenViewController: AuthScreenViewInterface {}
