//
//  RegistrationScreenViewController.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 24.10.2022.
//

import SnapKit
import UIKit

final class RegistrationScreenViewController: UIViewController {
    private lazy var button = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()

    // MARK: - Public properties -

    // swiftlint:disable:next implicitly_unwrapped_optional
    var presenter: RegistrationScreenPresenterInterface!

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    private func setupViews() {
        view.addSubview(button)

        button.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(100)
        }
    }

    @objc
    private func handleLogin() {
        presenter.login()
    }
}

// MARK: - Extensions -

extension RegistrationScreenViewController: RegistrationScreenViewInterface {}
