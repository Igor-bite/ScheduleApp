//
//  EmptyScheduleView.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 20.09.2022.
//

import Lottie
import SnapKit
import UIKit

final class EmptyScheduleView: UIView {
    var refreshAction: (() -> Void)?

    private let animation: LottieAnimationView = {
        let view = LottieAnimationView.relaxAnimation
        view.contentMode = .scaleAspectFit
        view.loopMode = .loop
        view.animationSpeed = 0.5
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
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

        animation.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(0.7)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(self.snp.width).multipliedBy(0.9)
        }
    }

    @objc
    private func buttonTapped() {
        refreshAction?()
    }
}
