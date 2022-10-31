//
//  ProfileScreenViewController.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 31.10.2022.
//

import UIKit

final class ProfileScreenViewController: UIViewController {
    // MARK: - Public properties -

    // swiftlint:disable:next implicitly_unwrapped_optional
    var presenter: ProfileScreenPresenterInterface!

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - Extensions -

extension ProfileScreenViewController: ProfileScreenViewInterface {}
