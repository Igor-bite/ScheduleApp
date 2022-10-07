//
//  CapsuleLabelView.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 20.09.2022.
//

import SnapKit
import UIKit

final class CapsuleLabelView: UIView {
    private enum Constants {
        static let height = 24.0
        static let cornerRadius = 12.0
    }

    private let label = {
        let label = UILabel.secondaryTextLabel
        label.textAlignment = .center
        label.textColor = .Pallette.textColor.darkThemeColor
        return label
    }()

    private var widthConstraint: Constraint?

    init() {
        super.init(frame: .zero)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(withText text: String, color: UIColor) {
        backgroundColor = color
        label.text = text

        widthConstraint?.update(offset: label.intrinsicContentSize.width + 20)
    }

    private func setupViews() {
        layer.cornerRadius = Constants.cornerRadius
        snp.makeConstraints { make in
            make.height.equalTo(Constants.height)
        }

        addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        snp.makeConstraints { make in
            self.widthConstraint = make.width.equalTo(label.intrinsicContentSize.width + 20).constraint
        }
    }
}
