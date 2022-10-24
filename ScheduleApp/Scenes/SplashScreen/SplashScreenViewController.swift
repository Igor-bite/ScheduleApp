//
//  SplashScreenViewController.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 26.09.2022.
//

import AsyncPlus
import Lottie
import SnapKit
import UIKit

final class SplashScreenViewController: UIViewController {
    private enum Constants {
        static let height = 284.0
        static let width = 199.0
        static let topOffset = 130.0
    }

    private let bgImageView = UIImageView(image: Asset.splashBg.image)

    private let animation: LottieAnimationView = {
        let view = LottieAnimationView.icon
        view.contentMode = .scaleAspectFit
        view.loopMode = .playOnce
        view.animationSpeed = 0.7
        return view
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.text = "Расписаниеееееееееееееее"
        label.textColor = .Pallette.textColor.themeInverted
        label.font = .roundedSystemFont(ofSize: 150, weight: .semibold)
        return label
    }()

    private let dismissAction: () -> Void

    // MARK: - Lifecycle -

    init(dismissAction: @escaping () -> Void) {
        self.dismissAction = dismissAction
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        auth()
    }

    private var labelRightConstraint: Constraint?
    private var canDismiss = false

    private func auth() {
        attempt {
            try await AuthService.shared.tryToRestoreLogin()
        }.then { user in
            print("Logged in as: \(user.firstName) \(user.secondName)")
            DispatchQueue.main.async {
                if self.canDismiss {
                    self.dismissAction()
                }
                self.canDismiss = true
            }
        }.catch { error in
            print(error)
            DispatchQueue.main.async {
                if self.canDismiss {
                    self.dismissAction()
                }
                self.canDismiss = true
            }
        }
    }

    func setupViews() {
        view.addSubview(bgImageView)
        view.addSubview(animation)
        view.addSubview(label)

        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        animation.snp.makeConstraints { make in
            make.height.equalTo(284)
            make.width.equalTo(199)
            make.top.equalTo(view.snp.top).offset(130)
            make.centerX.equalToSuperview()
        }

        label.snp.makeConstraints { make in
            make.width.equalTo(label.intrinsicContentSize.width)
            make.height.equalTo(label.intrinsicContentSize.height)
            make.top.equalTo(animation.snp.bottom).offset(50)
            self.labelRightConstraint = make.right.equalToSuperview().offset(label.intrinsicContentSize.width).constraint
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        animate()
    }

    private func animate() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.animation.play()

            self.labelRightConstraint?.update(inset: UIScreen.main.bounds.width)
            UIView.animate(withDuration: 3, delay: 0, options: .curveEaseInOut) {
                self.view.layoutIfNeeded()
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if self.canDismiss {
                    self.dismissAction()
                }
                self.canDismiss = true
            }
        }
    }
}
