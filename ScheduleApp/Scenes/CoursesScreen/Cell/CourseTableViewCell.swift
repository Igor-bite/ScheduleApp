//
//  CourseTableViewCell.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 27.09.2022.
//

import Lottie
import Reusable
import SkeletonView
import UIKit

class CourseTableViewCell: UITableViewCell, Reusable {
    private enum Constants {
        static let offset = 20.0

        static let cellOffset = 15.0
        static let cellCornerRadius = 15.0
    }

    private var course: CourseModel? {
        didSet {
            guard let course = course else { return }
            courseNameLabel.text = course.title
            let (university, place) = course.placeInfo()
            universityNameLabel.text = university
            placeInfoLabel.text = place
            courseTypeView.configure(withText: course.type.toText(), color: course.type.bgColor())
            isEnrolled = course.isEnrolled ?? false
        }
    }

    private let courseTypeView = CapsuleView()
    private let courseNameLabel = {
        let label = UILabel.titleLabel
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()

    private let universityNameLabel = {
        let label = UILabel.secondaryTextLabel
        label.textAlignment = .center
        return label
    }()

    private lazy var placeInfoLabel = {
        let label = UILabel.secondaryTextLabel
        label.textAlignment = .left
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlePlaceInfoTap)))
        return label
    }()

    private let enrollButtonView = {
        let view = CapsuleView()
        view.configure(withText: "Записаться", color: .Pallette.blue)
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var isEnrolled = false {
        didSet {
            enrollButtonView.configure(withText: isEnrolled ? "Вы записаны" : "Записаться",
                                       color: isEnrolled ? .Pallette.green : .Pallette.blue)
        }
    }

    func configure(with course: CourseModel, enrollAction: @escaping (Bool) -> Void) {
        if course.curatorId == 1 {
            enrollButtonView.configure(withText: "Ваш курс", color: .Pallette.purple)
            enrollButtonView.isUserInteractionEnabled = false
        } else {
            enrollButtonView.configure(withText: "Записаться", color: .Pallette.blue)
            enrollButtonView.isUserInteractionEnabled = true
        }
        self.course = course

        enrollButtonView.tapAction = {
            self.isEnrolled.toggle()

            enrollAction(self.isEnrolled)
        }
    }

    func setupViews() {
        let containerView = UIView()
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Constants.cellOffset)
            make.right.equalToSuperview().inset(Constants.cellOffset)
            make.top.equalToSuperview().offset(Constants.cellOffset / 2)
            make.bottom.equalToSuperview().inset(Constants.cellOffset / 2)
        }
        containerView.layer.cornerRadius = Constants.cellCornerRadius
        containerView.layer.masksToBounds = true
        containerView.backgroundColor = .Pallette.cellBgColor

        containerView.addSubview(courseTypeView)
        containerView.addSubview(universityNameLabel)
        containerView.addSubview(courseNameLabel)
        containerView.addSubview(placeInfoLabel)
        containerView.addSubview(enrollButtonView)

        courseTypeView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(Constants.offset / 2)
            make.width.lessThanOrEqualTo(containerView.snp.width).multipliedBy(0.3)
        }

        universityNameLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(Constants.offset / 2)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.centerY.equalTo(courseTypeView)
        }

        courseNameLabel.snp.makeConstraints { make in
            make.top.equalTo(courseTypeView.snp.bottom).offset(Constants.offset / 1.5)
            make.left.equalToSuperview().offset(Constants.offset)
            make.right.equalToSuperview().inset(Constants.offset)
        }

        placeInfoLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(Constants.offset / 2)
            make.top.greaterThanOrEqualTo(courseNameLabel.snp.bottom).offset(Constants.offset / 2)
            make.left.equalToSuperview().offset(Constants.offset)
        }

        enrollButtonView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(Constants.offset / 2)
            make.left.greaterThanOrEqualTo(placeInfoLabel.snp.right).offset(Constants.offset / 2)
            make.right.equalToSuperview().inset(Constants.offset / 2)
        }
    }

    @objc
    private func handlePlaceInfoTap() {
        guard let course = course else { return }
        switch course.type {
        case .online(let onlineInfo):
            guard let urlString = onlineInfo.lessonUrl,
                  let url = URL(string: urlString)
            else { return }

            UIApplication.shared.open(url)
        case .offline:
            break
        default:
            break
        }
    }
}
