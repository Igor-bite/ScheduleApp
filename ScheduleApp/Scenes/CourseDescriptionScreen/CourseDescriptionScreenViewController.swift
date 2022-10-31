//
//  CourseDescriptionScreenViewController.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 25.10.2022.
//

import SnapKit
import UIKit

final class CourseDescriptionScreenViewController: UIViewController {
    private enum Constants {
        static let offset = 10.0
        static let lessonRowHeight = 160.0
    }

    private lazy var leftBarButton = {
        let button = UIButton.barButton
        button.setTitle("Назад", for: .normal)
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return button
    }()

    private lazy var rightBarButton = {
        let button = UIButton.barButton
        button.setTitle("Изменить", for: .normal)
        button.addTarget(self, action: #selector(changeCourse), for: .touchUpInside)
        let curUser = AuthService.shared.currentUser
        if !(curUser?.isAdmin ?? false), presenter.course.curatorId != curUser?.id {
            button.isHidden = true
        }
        return button
    }()

    private let courseInfoView = CourseTableViewCell(frame: .zero)

    private lazy var lessonsLabel = {
        let label = UILabel.titleLabel
        label.text = "Уроки"
        label.textAlignment = .center
        label.backgroundColor = .Pallette.mainBgColor
        label.clipsToBounds = true
        label.layer.cornerRadius = 10
        return label
    }()

    private lazy var lessonsTable: UITableView = {
        let table = UITableView()
        table.showsVerticalScrollIndicator = false
        table.rowHeight = Constants.lessonRowHeight
        table.dataSource = self
        table.delegate = self
        table.register(cellType: LessonTableViewCell.self)
        table.separatorStyle = .none
        table.layer.cornerRadius = 15
        table.clipsToBounds = true
        table.refreshControl = .init()
        table.refreshControl?.addTarget(self, action: #selector(refreshLessons), for: .valueChanged)
        table.refreshControl?.beginRefreshing()
        return table
    }()

    private lazy var addLessonButton = {
        let button = UIButton.barButton
        button.setTitle("Добавить урок", for: .normal)
        button.addTarget(self, action: #selector(addLesson), for: .touchUpInside)
        let curUser = AuthService.shared.currentUser
        if !(curUser?.isAdmin ?? false), presenter.course.curatorId != curUser?.id {
            button.isHidden = true
        }
        return button
    }()

    // MARK: - Public properties -

    // swiftlint:disable:next implicitly_unwrapped_optional
    var presenter: CourseDescriptionScreenPresenterInterface!

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .Pallette.mainBgColor
        setupViews()
        refreshLessons()
        reloadCourseInfo()
    }

    @objc
    private func refreshLessons() {
        presenter.lessons()
    }

    private func setupViews() {
        view.addSubview(leftBarButton)
        view.addSubview(rightBarButton)
        view.addSubview(lessonsTable)
        view.addSubview(addLessonButton)

        leftBarButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Constants.offset)
            make.top.equalTo(view.snp.topMargin).offset(Constants.offset)
            make.width.equalTo(view.snp.width).dividedBy(5)
            make.height.equalTo(25)
        }

        rightBarButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(Constants.offset)
            make.top.equalTo(view.snp.topMargin).offset(Constants.offset)
            make.width.equalTo(view.snp.width).dividedBy(4)
            make.height.equalTo(25)
        }

        lessonsTable.snp.makeConstraints { make in
            make.top.equalTo(leftBarButton.snp.bottom).offset(Constants.offset)
            make.left.right.equalToSuperview()
            let curUser = AuthService.shared.currentUser
            if !(curUser?.isAdmin ?? false), presenter.course.curatorId != curUser?.id {
                make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            } else {
                make.bottom.equalTo(addLessonButton.snp.top).inset(-20)
            }
        }

        addLessonButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

    @objc
    private func goBack() {
        presenter.dismiss()
    }

    @objc
    private func changeCourse() {
        presenter.change()
    }

    @objc
    private func addLesson() {
        presenter.addLesson()
    }
}

// MARK: - Extensions -

extension CourseDescriptionScreenViewController: CourseDescriptionScreenViewInterface {
    func reloadCourseInfo() {
        DispatchQueue.main.async {
            self.courseInfoView.configure(with: self.presenter.course) { isEnrolled in
                if isEnrolled {
                    self.presenter.enroll()
                } else {
                    self.presenter.leave()
                }
            }
        }
    }

    func reloadLessons() {
        DispatchQueue.main.async {
            self.lessonsTable.refreshControl?.endRefreshing()
            if self.presenter.numberOfLessons == 0 {
                self.lessonsLabel.text = "Уроков пока нет"
            } else {
                self.lessonsLabel.text = "Уроки"
            }
            self.setupLessonsLabelConstraints()
            self.lessonsTable.reloadData()
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
}

extension CourseDescriptionScreenViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        presenter.numberOfLessons
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LessonTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        if let lesson = presenter.lesson(forIndexPath: indexPath) {
            cell.configure(with: lesson, shouldShowDate: true) {
                self.presenter.changeLesson(atIndexPath: indexPath)
            }
        }
        return cell
    }
}

extension CourseDescriptionScreenViewController: UITableViewDelegate {
    func tableView(_: UITableView, viewForHeaderInSection _: Int) -> UIView? {
        let view = UIView()
        view.addSubview(courseInfoView)
        view.addSubview(lessonsLabel)

        courseInfoView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(view.snp.width)
            make.height.equalTo(Constants.lessonRowHeight)
        }

        setupLessonsLabelConstraints()

        return view
    }

    private func setupLessonsLabelConstraints() {
        lessonsLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(courseInfoView.snp.bottom).offset(Constants.offset)
            make.width.equalTo(170)
        }
    }

    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        Constants.lessonRowHeight + 45.0
    }
}
