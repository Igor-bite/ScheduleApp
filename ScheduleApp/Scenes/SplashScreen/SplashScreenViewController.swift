//
//  SplashScreenViewController.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 26.09.2022.
//

import UIKit
import SnapKit
import Lottie

public final class SplashScreenViewController: UIViewController {
	private enum Constants {
		static let height = 284.0
		static let width = 199.0
		static let topOffset = 130.0
	}
	private let bgImageView = UIImageView(image: UIImage(named: "splash-bg"))
	private let animation: AnimationView = {
		let view = AnimationView.icon
		view.contentMode = .scaleAspectFit
		view.loopMode = .playOnce
		view.animationSpeed = 0.7
		return view
	}()

    // MARK: - Public properties -

	// swiftlint:disable:next implicitly_unwrapped_optional
    var presenter: SplashScreenPresenterInterface!

    // MARK: - Lifecycle -

    public override func viewDidLoad() {
        super.viewDidLoad()

		setupViews()
    }

	func setupViews() {
		view.addSubview(bgImageView)
		view.addSubview(animation)

		bgImageView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}

		animation.snp.makeConstraints { make in
			make.height.equalTo(284)
			make.width.equalTo(199)
			make.top.equalTo(view.snp.top).offset(130)
			make.centerX.equalToSuperview()
		}
	}

	public override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
			self.animation.play { _ in
				self.presenter.dismiss()
			}
		}
	}
}

// MARK: - Extensions -

extension SplashScreenViewController: SplashScreenViewInterface {
}
