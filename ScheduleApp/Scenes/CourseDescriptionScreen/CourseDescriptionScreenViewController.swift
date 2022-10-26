//
//  CourseDescriptionScreenViewController.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 25.10.2022.
//

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
        if presenter.course.curatorId != AuthService.shared.currentUser?.id {
            button.isHidden = true
        }
        return button
    }()

    private let courseInfoView = CourseTableViewCell(frame: .zero)

    private lazy var lessonsLabel = {
        let label = UILabel.titleLabel
        label.text = "Уроки"
        label.textAlignment = .center
        return label
    }()

    private lazy var lessonsTable: UITableView = {
        let table = UITableView()
        table.showsVerticalScrollIndicator = false
        table.rowHeight = Constants.lessonRowHeight
        table.dataSource = self
        table.register(cellType: LessonTableViewCell.self)
        table.separatorStyle = .none
        return table
    }()

    private lazy var addLessonButton = {
        let button = UIButton.barButton
        button.setTitle("Добавить урок", for: .normal)
        button.addTarget(self, action: #selector(addLesson), for: .touchUpInside)
        if presenter.course.curatorId != AuthService.shared.currentUser?.id {
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
        courseInfoView.configure(with: presenter.course) { _ in }
        setupViews()
        presenter.lessons()
    }

    private func setupViews() {
        view.addSubview(leftBarButton)
        view.addSubview(rightBarButton)
        view.addSubview(courseInfoView)
        view.addSubview(lessonsLabel)
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

        courseInfoView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(leftBarButton.snp.bottom).offset(Constants.offset)
            make.width.equalTo(view.snp.width)
            make.height.equalTo(160)
        }

        lessonsLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(courseInfoView.snp.bottom).offset(Constants.offset)
            make.width.equalTo(view.snp.width).inset(20)
        }

        lessonsTable.snp.makeConstraints { make in
            make.top.equalTo(lessonsLabel.snp.bottom).offset(Constants.offset)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(addLessonButton.snp.top).offset(20)
        }

        addLessonButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(70)
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
    private func addLesson() {}
}

// MARK: - Extensions -

extension CourseDescriptionScreenViewController: CourseDescriptionScreenViewInterface {
    func reloadCourseInfo() {
        DispatchQueue.main.async {
            self.courseInfoView.configure(with: self.presenter.course) { _ in }
        }
    }

    func reloadLessons() {
        DispatchQueue.main.async {
            self.lessonsTable.reloadData()
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
            cell.configure(with: lesson)
        }
        return cell
    }
}
