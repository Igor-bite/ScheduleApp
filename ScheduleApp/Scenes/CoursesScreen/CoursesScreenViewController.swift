//
//  CoursesScreenViewController.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 27.09.2022.
//

import UIKit
import Reusable
import SnapKit
import GradientLoadingBar

public final class CoursesScreenViewController: UIViewController {
	private enum Constants {
		static let offset = 10.0
		static let courseRowHeight = 160.0
		static let loadingBarHeight = 4.0
	}

	private lazy var createCourseButton = {
		let button = UIButton()
		button.backgroundColor = .blueColor
		button.layer.cornerRadius = 7
		button.setTitle("Создать", for: .normal)
		button.titleLabel?.font = .text
		button.addTarget(self, action: #selector(createNewCourse), for: .touchUpInside)
		return button
	}()

	private lazy var titleLabel = {
		let label = UILabel()
		label.font = .title
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

	private let gradientLoadingBar = GradientLoadingBar(
		height: Constants.loadingBarHeight,
		isRelativeToSafeArea: true
	)

    // MARK: - Public properties -

    // swiftlint:disable:next implicitly_unwrapped_optional
    var presenter: CoursesScreenPresenterInterface!

    // MARK: - Lifecycle -

    public override func viewDidLoad() {
        super.viewDidLoad()
		navigationController?.isNavigationBarHidden = true

		setupViews()
		refresh()
    }

	private func setupViews() {
		view.backgroundColor = .white

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

	@objc
	private func createNewCourse() {

	}
}

// MARK: - Extensions -

extension CoursesScreenViewController: CoursesScreenViewInterface {
	public func reloadData() {
		DispatchQueue.main.async { [weak self] in
			self?.gradientLoadingBar.fadeOut()
			if let count = self?.presenter.numberOfItems,
			   count == .zero {
			} else {
				self?.table.reloadData()
				self?.table.refreshControl?.endRefreshing()
			}
		}
	}

	@objc
	public func refresh() {
		presenter.fetchLessons()
		gradientLoadingBar.fadeIn()
	}
}

// MARK: - Lessons table view

extension CoursesScreenViewController: UITableViewDataSource {
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		presenter.numberOfItems
	}

	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: CourseTableViewCell = tableView.dequeueReusableCell(for: indexPath)
		let course = presenter.item(at: indexPath)
		cell.configure(with: course)
		return cell
	}
}

extension CoursesScreenViewController: UITableViewDelegate {
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		presenter.itemSelected(at: indexPath)
		tableView.deselectRow(at: indexPath, animated: true)
	}
}
