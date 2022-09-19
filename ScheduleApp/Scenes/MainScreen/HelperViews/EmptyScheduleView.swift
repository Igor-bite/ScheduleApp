//
//  EmptyScheduleView.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 20.09.2022.
//  Copyright © 2022 messeb.com. All rights reserved.
//

import UIKit
import SnapKit
import Lottie

final class EmptyScheduleView: UIView {
	private enum Constants {
		static let buttonWidth = 200.0
		static let buttonOffset = 30.0
		static let buttonColor = UIColor(red: 1 / 255, green: 186 / 255, blue: 239 / 255, alpha: 1)
	}

	var refreshAction: (() -> Void)?

	private let animation: AnimationView = {
		let view = AnimationView.relaxAnimation
		view.contentMode = .scaleAspectFit
		view.loopMode = .loop
		view.animationSpeed = 0.5
		return view
	}()

	private let refreshButton: UIButton = {
		let button = UIButton(frame: .zero)
		button.setTitle("Refresh", for: .normal)
		button.backgroundColor = Constants.buttonColor
		button.setTitleColor(.white, for: .normal)
		button.layer.cornerRadius = 10
		button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
		return button
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)

		setupViews()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func playAnimation() {
		animation.play()
	}

	func stopAnimation() {
		animation.stop()
	}

	private func setupViews() {
		addSubview(animation)
		addSubview(refreshButton)

		animation.snp.makeConstraints { make in
			make.centerY.equalToSuperview().multipliedBy(0.7)
			make.centerX.equalToSuperview()
			make.width.equalToSuperview().multipliedBy(0.9)
			make.height.equalTo(self.snp.width).multipliedBy(0.9)
		}

		refreshButton.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.width.equalTo(Constants.buttonWidth)
			make.top.equalTo(animation.snp.bottom).offset(Constants.buttonOffset)
		}
	}

	@objc
	private func buttonTapped() {
		refreshAction?()
	}
}
