//
//  ProfileScreenViewController.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 31.10.2022.
//

import CocoaTextField
import SnapKit
import UIKit

final class ProfileScreenViewController: UIViewController {
    private lazy var logoutButton = {
        let button = UIButton.barButton
        button.setTitle("Выйти", for: .normal)
        button.addTarget(self, action: #selector(logout), for: .touchUpInside)
        return button
    }()

    private lazy var titleLabel = {
        let label = UILabel.titleLabel
        label.textAlignment = .center
        return label
    }()

    private lazy var createButton = {
        let button = UIButton.barButton
        button.setTitle("Создать", for: .normal)
        button.addTarget(self, action: #selector(createNewUserCourse), for: .touchUpInside)
        return button
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
        return textField
    }()

    private lazy var saveButton: UIButton = {
        let button = UIButton.barButton
        button.layer.cornerRadius = 15
        button.setTitle("Сохранить", for: .normal)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var changePasswordButton: UIButton = {
        let button = UIButton.barButton
        button.layer.cornerRadius = 15
        button.setTitle("Сменить пароль", for: .normal)
        button.addTarget(self, action: #selector(changePasswordButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var removeButton: UIButton = {
        let button = UIButton.barButton
        button.backgroundColor = .red
        button.layer.cornerRadius = 15
        button.setTitle("Стереть аккаунт", for: .normal)
        button.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Public properties -

    // swiftlint:disable:next implicitly_unwrapped_optional
    var presenter: ProfileScreenPresenterInterface!

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .Pallette.mainBgColor
        setupViews()
        setUserData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUserData()
    }

    private func setupViews() {
        view.addSubview(logoutButton)
        view.addSubview(titleLabel)
        view.addSubview(createButton)
        view.addSubview(firstNameInput)
        view.addSubview(secondNameInput)
        view.addSubview(lastNameInput)
        view.addSubview(saveButton)
        view.addSubview(changePasswordButton)
        view.addSubview(removeButton)

        logoutButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(view.snp.topMargin).offset(10)
            make.width.equalTo(view.snp.width).dividedBy(5)
            make.height.equalTo(25)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.snp.topMargin).offset(10)
            make.width.equalTo(view.snp.width).dividedBy(2)
        }
        createButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(10)
            make.top.equalTo(view.snp.topMargin).offset(10)
            make.width.equalTo(view.snp.width).dividedBy(5)
            make.height.equalTo(25)
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
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(lastNameInput.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
        changePasswordButton.snp.makeConstraints { make in
            make.top.equalTo(saveButton.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
        removeButton.snp.makeConstraints { make in
            make.top.equalTo(changePasswordButton.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
    }

    private func setUserData() {
        guard let curUser = AuthService.shared.currentUser else { return }
        titleLabel.text = "Привет, \(curUser.firstName)!"
        firstNameInput.text = curUser.firstName
        secondNameInput.text = curUser.secondName
        lastNameInput.text = curUser.lastName
    }

    @objc
    private func saveButtonTapped() {
        print("saveButtonTapped")
    }

    @objc
    private func changePasswordButtonTapped() {
        print("changePasswordButtonTapped")
    }

    @objc
    private func removeButtonTapped() {
        print("removeButtonTapped")
    }

    @objc
    private func logout() {}

    @objc
    private func createNewUserCourse() {}
}

// MARK: - Extensions -

extension ProfileScreenViewController: ProfileScreenViewInterface {}
