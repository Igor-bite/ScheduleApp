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
	private enum Constants {
		static let offset = 10.0
		static let lessonRowHeight = 160.0
		static let loadingBarHeight = 4.0
	}

	private lazy var todayButton = {
		let button = UIButton()
		button.backgroundColor = .blueColor
		button.layer.cornerRadius = 7
		button.setTitle("Сегодня", for: .normal)
		button.titleLabel?.font = .text
		button.addTarget(self, action: #selector(selectToday), for: .touchUpInside)
		return button
	}()

	private lazy var titleLabel = {
		let label = UILabel()
		label.font = .title
		label.text = "Расписание"
		label.textAlignment = .center
		return label
	}()

	private let weekView = JTACMonthView()

	private lazy var table: UITableView = {
		let table = UITableView()
		table.showsVerticalScrollIndicator = false
		table.rowHeight = Constants.lessonRowHeight
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
		height: Constants.loadingBarHeight,
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

		view.addSubview(titleLabel)
		view.addSubview(todayButton)
		view.addSubview(weekView)
		view.addSubview(table)
		view.addSubview(whenEmptyView)

		todayButton.snp.makeConstraints { make in
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

		weekView.snp.makeConstraints { make in
			make.left.right.equalToSuperview()
			make.top.equalTo(todayButton.snp.bottom).offset(Constants.offset)
			make.height.equalTo(DateCell.height)
		}

		table.snp.makeConstraints { make in
			make.right.left.equalToSuperview()
			make.top.equalTo(weekView.snp.bottom).offset(Constants.offset)
			make.bottom.equalToSuperview()
		}

		whenEmptyView.snp.makeConstraints { make in
			make.right.left.equalToSuperview()
			make.top.equalTo(weekView.snp.bottom).offset(Constants.offset)
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
		selectToday()

		weekView.scrollDirection = .horizontal
		weekView.scrollingMode = .stopAtEachCalendarFrame
		weekView.showsHorizontalScrollIndicator = false
	}

	@objc
	private func selectToday() {
		weekView.scrollToDate(.init())
		weekView.selectDates([.init()])
		updateTodayButton(with: false)
		presenter.setDate(.init())
	}

	private func updateTodayButton(with isActive: Bool) {
		guard todayButton.isUserInteractionEnabled != isActive
		else { return }
		todayButton.isUserInteractionEnabled = isActive
		todayButton.backgroundColor = isActive ? .blueColor : .grayColor
		todayButton.setTitleColor(isActive ? .white : .gray, for: .normal)
	}
}

// MARK: - Extensions -

extension ScheduleScreenViewController: ScheduleScreenViewInterface {
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
		let startTimeInterval = DateComponents(month: -6)
		let endTimeInterval = DateComponents(month: 6)

		let start = Calendar.current.date(byAdding: startTimeInterval, to: Date())
		let end = Calendar.current.date(byAdding: endTimeInterval, to: Date())
		return ConfigurationParameters(startDate: start ?? .distantPast,
									   endDate: end ?? .distantFuture,
									   numberOfRows: 1,
									   generateInDates: .forFirstMonthOnly,
									   generateOutDates: .off,
									   firstDayOfWeek: .monday,
									   hasStrictBoundaries: false)
	}
}

extension ScheduleScreenViewController: JTACMonthViewDelegate {
	private func configureCell(view: JTACDayCell?, cellState: CellState) {
		guard let view = view as? DateCell
		else { return }
		view.isToday = cellState.date.isToday()
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
		guard let cell = cell as? DateCell
		else { return }
		updateTodayButton(with: cell.isSelected && !cell.isToday)
		if cellState.selectionType == .userInitiated {
			cell.isSelected.toggle()
			presenter.setDate(date)
		}
	}

	public func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
		if visibleDates.monthDates.contains(where: { $0.0.isToday() }) {
			let isTodaySelected = calendar.selectedDates.contains { $0.isToday() }
			updateTodayButton(with: !isTodaySelected)
		} else {
			updateTodayButton(with: true)
		}
	}
}
