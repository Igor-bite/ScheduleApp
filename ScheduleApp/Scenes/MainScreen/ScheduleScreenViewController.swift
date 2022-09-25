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
import JTAppleCalendar

public final class ScheduleScreenViewController: UIViewController {
	private let weekView = JTACMonthView()

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
		self.navigationController?.isNavigationBarHidden = true

		setupViews()
		configureWeekView()
		refresh()
	}

	private func setupViews() {
		view.backgroundColor = .white

		view.addSubview(weekView)
		view.addSubview(table)
		view.addSubview(whenEmptyView)

		weekView.snp.makeConstraints { make in
			make.left.right.equalToSuperview()
			make.top.equalTo(view.snp.topMargin).offset(10)
			make.height.equalTo(DateCell.height)
		}

		table.snp.makeConstraints { make in
			make.right.left.equalToSuperview()
			make.top.equalTo(weekView.snp.bottom).offset(10)
			make.bottom.equalToSuperview()
		}

		whenEmptyView.snp.makeConstraints { make in
			make.right.left.equalToSuperview()
			make.top.equalTo(weekView.snp.bottom).offset(10)
			make.bottom.equalToSuperview()
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

	private func configureWeekView() {
		weekView.calendarDelegate = self
		weekView.calendarDataSource = self
		weekView.register(cellType: DateCell.self)
		weekView.cellSize = UIScreen.main.bounds.width / 7
		weekView.scrollToDate(.init())
		weekView.selectDates([.init()])

		weekView.scrollDirection = .horizontal
		weekView.scrollingMode = .stopAtEachCalendarFrame
		weekView.showsHorizontalScrollIndicator = false
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
		presenter.fetchLessons()
		gradientLoadingBar.fadeIn()
	}
}

// MARK: - Lessons table view

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

// MARK: - Weekdays view

extension ScheduleScreenViewController: JTACMonthViewDataSource {
	public func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
		let startTimeInterval = DateComponents(month: -1)
		let endTimeInterval = DateComponents(month: 1)

		let start = Calendar.current.date(byAdding: startTimeInterval, to: Date())
		let end = Calendar.current.date(byAdding: endTimeInterval, to: Date())

		return ConfigurationParameters(startDate: start ?? .distantPast,
									   endDate: end ?? .distantFuture,
									   numberOfRows: 1,
									   generateInDates: .forFirstMonthOnly,
									   generateOutDates: .tillEndOfRow,
									   firstDayOfWeek: .monday,
									   hasStrictBoundaries: true)
	}
}

extension ScheduleScreenViewController: JTACMonthViewDelegate {
	private func configureCell(view: JTACDayCell?, cellState: CellState) {
		guard let view = view as? DateCell
		else { return }
		if cellState.date == Date() {
			view.isSelected = true
		}
		view.dayNumber = cellState.text
		view.weekday = cellState.day
	}

	public func calendar(_ calendar: JTAppleCalendar.JTACMonthView,
						 willDisplay cell: JTAppleCalendar.JTACDayCell,
						 forItemAt date: Date,
						 cellState: JTAppleCalendar.CellState,
						 indexPath: IndexPath) {
		configureCell(view: cell, cellState: cellState)
	}

	public func calendar(_ calendar: JTAppleCalendar.JTACMonthView,
						 cellForItemAt date: Date,
						 cellState: JTAppleCalendar.CellState,
						 indexPath: IndexPath) -> JTAppleCalendar.JTACDayCell {
		let cell: DateCell = calendar.dequeueReusableCell(for: indexPath)
		self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
		return cell
	}

	public func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
		cell?.isSelected.toggle()
		presenter.setDate(date)
	}
}
