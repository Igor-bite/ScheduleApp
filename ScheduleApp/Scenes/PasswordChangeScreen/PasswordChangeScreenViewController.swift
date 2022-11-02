//
//  PasswordChangeScreenViewController.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 01.11.2022.
//

import CocoaTextField
import SnapKit
import UIKit

final class PasswordChangeScreenViewController: UIViewController {
    enum Constants {
        static let submitButtonHeight = 48
        static let gapHeight = 20
        static let sideOffset = 16
        static let sectionHeight = 44
        static let twoThirdsSections = sectionHeight / 3 * 2
    }

    private lazy var labelView: UILabel = {
        let view = UILabel.titleLabel
        view.text = "Смена пароля"
        return view
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 14
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.backgroundColor = .Pallette.mainBgColor
        return view
    }()

    private lazy var currentPasswordInput = {
        let textField = CocoaTextField()
        textField.placeholder = "Текущий пароль"
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

    private lazy var newPasswordInput = {
        let textField = CocoaTextField()
        textField.placeholder = "Новый пароль"
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

    private lazy var secondTimePasswordInput = {
        let textField = CocoaTextField()
        textField.placeholder = "Новый пароль ещё раз"
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
        button.setTitle("Изменить", for: .normal)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(changePassword), for: .touchUpInside)
        return button
    }()

    // MARK: - Public properties -

    // swiftlint:disable:next implicitly_unwrapped_optional
    var presenter: PasswordChangeScreenPresenterInterface!

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
        currentPasswordInput.becomeFirstResponder()
    }

    private func setupViews() {
        view.addSubview(contentView)
        contentView.addSubview(labelView)
        contentView.addSubview(currentPasswordInput)
        contentView.addSubview(newPasswordInput)
        contentView.addSubview(secondTimePasswordInput)
        contentView.addSubview(submitButton)

        makeConstraints()
    }

    @objc
    private func changePassword() {
        guard let curPass = currentPasswordInput.text?.nilIfEmpty,
              presenter.validateCurrentPassword(pass: curPass)
        else {
            currentPasswordInput.setError(errorString: "Not correct")
            return
        }

        guard let newPass = newPasswordInput.text?.nilIfEmpty else {
            newPasswordInput.setError(errorString: "")
            return
        }

        guard let secondTime = secondTimePasswordInput.text?.nilIfEmpty,
              secondTime == newPass
        else {
            secondTimePasswordInput.setError(errorString: "Not equals")
            return
        }

        presenter.changePassword(new: newPass)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Extensions -

extension PasswordChangeScreenViewController: PasswordChangeScreenViewInterface {}

private extension PasswordChangeScreenViewController {
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
            make.bottom.equalTo(currentPasswordInput.snp.top).offset(-Constants.gapHeight)
        }
        currentPasswordInput.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.sideOffset)
            make.trailing.equalToSuperview().inset(Constants.sideOffset)
            make.height.equalTo(Constants.sectionHeight)
            make.bottom.equalTo(newPasswordInput.snp.top).offset(-Constants.gapHeight)
        }
        newPasswordInput.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Constants.sideOffset)
            make.right.equalToSuperview().inset(Constants.sideOffset)
            make.height.equalTo(Constants.sectionHeight)
            make.bottom.equalTo(secondTimePasswordInput.snp.top).offset(-Constants.gapHeight)
        }
        secondTimePasswordInput.snp.makeConstraints { make in
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
