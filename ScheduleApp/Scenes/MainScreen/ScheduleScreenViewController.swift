//
//  ScheduleScreenViewController.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 15.09.2022.
//

import UIKit
import Reusable
import SnapKit
import GradientLoadingBar

public final class ScheduleScreenViewController: UIViewController {
	private lazy var table: UITableView = {
		let table = UITableView()
		table.showsVerticalScrollIndicator = false
		table.rowHeight = 160
		table.delegate = self
		table.dataSource = self
		table.register(cellType: LessonTableViewCell.self)
		table.separatorStyle = .none
		table.refreshControl = UIRefreshControl()
		table.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
		return table
	}()

	private lazy var whenEmptyView: EmptyScheduleView = {
		let view = EmptyScheduleView(frame: .zero)
		view.refreshAction = {
			self.refresh()
		}
		return view
	}()

	private let gradientLoadingBar = GradientLoadingBar(
		height: 4.0,
		isRelativeToSafeArea: true
	)

	private var hasNoSchedule: Bool = false {
		didSet {
			guard self.hasNoSchedule != oldValue
			else { return }

			if self.hasNoSchedule {
				self.showEmptyView()
			} else {
				self.showSchedule()
			}
		}
	}

	// MARK: - Public properties -

	// swiftlint:disable:next implicitly_unwrapped_optional
	var presenter: ScheduleScreenPresenterInterface!

	// MARK: - Lifecycle -

	public override func viewDidLoad() {
		super.viewDidLoad()

		setupViews()
		refresh()
	}

	private func setupViews() {
		view.addSubview(weekView)
		view.addSubview(table)
		view.addSubview(whenEmptyView)

		table.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}

		whenEmptyView.snp.makeConstraints { make in
			make.centerX.centerY.equalToSuperview()
			make.height.width.equalToSuperview()
		}

		whenEmptyView.isHidden = true
	}

	private func showEmptyView() {
		whenEmptyView.isHidden = false
		whenEmptyView.playAnimation()
		table.isHidden = true
	}

	private func showSchedule() {
		whenEmptyView.isHidden = true
		whenEmptyView.stopAnimation()
		table.isHidden = false
	}
}

// MARK: - Extensions -

extension ScheduleScreenViewController: MainScreenViewInterface {
	public func reloadData() {
		DispatchQueue.main.async { [weak self] in
			self?.gradientLoadingBar.fadeOut()
			if let count = self?.presenter.numberOfItems,
			   count == .zero {
				self?.hasNoSchedule = true
			} else {
				self?.hasNoSchedule = false
				self?.table.reloadData()
				self?.table.refreshControl?.endRefreshing()
			}
		}
	}

	@objc
	public func refresh() {
		presenter.loadLessons()
		gradientLoadingBar.fadeIn()
	}
}

extension ScheduleScreenViewController: UITableViewDataSource {
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		presenter.numberOfItems
	}

	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: LessonTableViewCell = tableView.dequeueReusableCell(for: indexPath)
		let lesson = presenter.item(at: indexPath)
		cell.configure(with: lesson)
		return cell
	}
}

extension ScheduleScreenViewController: UITableViewDelegate {
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		presenter.itemSelected(at: indexPath)
		tableView.deselectRow(at: indexPath, animated: true)
	}
}
