//
//  CoursesScreenViewController.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 27.09.2022.
//

import Reusable
import SnapKit
import UIKit

final class CoursesScreenViewController: UIViewController {
    private enum Constants {
        static let offset = 10.0
        static let courseRowHeight = 160.0
    }

    private lazy var createCourseButton = {
        let button = UIButton.barButton
        button.setTitle("Создать", for: .normal)
        button.addTarget(self, action: #selector(createNewCourse), for: .touchUpInside)
        return button
    }()

    private lazy var titleLabel = {
        let label = UILabel.titleLabel
        label.text = "Курсы"
        label.textAlignment = .center
        return label
    }()

    private lazy var table: UITableView = {
        let table = UITableView()
        table.showsVerticalScrollIndicator = false
        table.rowHeight = Constants.courseRowHeight
        table.delegate = self
        table.dataSource = self
        table.register(cellType: CourseTableViewCell.self)
        table.separatorStyle = .none
        table.refreshControl = UIRefreshControl()
        table.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return table
    }()

    // MARK: - Public properties -

    // swiftlint:disable:next implicitly_unwrapped_optional
    var presenter: CoursesScreenPresenterInterface!

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true

        setupViews()
        refresh()
    }

    private func setupViews() {
        view.backgroundColor = .Pallette.mainBgColor

        view.addSubview(titleLabel)
        view.addSubview(createCourseButton)
        view.addSubview(table)

        createCourseButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(Constants.offset)
            make.top.equalTo(view.snp.topMargin).offset(Constants.offset)
            make.width.equalTo(view.snp.width).dividedBy(5)
            make.height.equalTo(25)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.snp.topMargin).offset(Constants.offset)
            make.width.equalTo(view.snp.width).dividedBy(2)
        }

        table.snp.makeConstraints { make in
            make.right.left.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.offset)
            make.bottom.equalToSuperview()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }

    @objc
    private func createNewCourse() {
        presenter.createNewCourse()
    }
}

// MARK: - Extensions -

extension CoursesScreenViewController: CoursesScreenViewInterface {
    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            if let count = self?.presenter.numberOfItems,
               count == .zero
            {
            } else {
                self?.table.reloadData()
                self?.table.refreshControl?.endRefreshing()
            }
        }
    }

    @objc
    func refresh() {
        presenter.fetchCourses()
    }

    func insertNewCourse(at indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.table.beginUpdates()
            self.table.insertRows(at: [indexPath], with: .automatic)
            self.table.endUpdates()
        }
    }
}

// MARK: - Courses table view

extension CoursesScreenViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        presenter.numberOfItems
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CourseTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        let course = presenter.item(at: indexPath)
        cell.configure(with: course) { shouldEnroll in
            if shouldEnroll {
                self.presenter.enrollOnCourse(at: indexPath)
            } else {
                self.presenter.leaveCourse(at: indexPath)
            }
        }
        return cell
    }

    func tableView(_: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point _: CGPoint) -> UIContextMenuConfiguration?
    {
        let curUser = AuthService.shared.currentUser
        let course = presenter.item(at: indexPath)
        if !(curUser?.isAdmin ?? false), course.curatorId != curUser?.id {
            return nil
        }
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let action = UIAction(title: "Удалить", image: .init(.trash.fill), attributes: [.destructive]) { _ in
                self.presenter.removeCourse(atIndexPath: indexPath)
            }
            return UIMenu(children: [action])
        }
    }
}

extension CoursesScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.itemSelected(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
