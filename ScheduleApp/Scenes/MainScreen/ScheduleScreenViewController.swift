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

		setupViews()
		configureWeekView()
		refresh()
	}

	private func setupViews() {
		view.addSubview(weekView)
		view.addSubview(table)
		view.addSubview(whenEmptyView)

		weekView.snp.makeConstraints { make in
			make.left.right.bottom.equalToSuperview()
			make.height.equalTo(150)
		}

		table.snp.makeConstraints { make in
			make.left.right.top.equalToSuperview()
			make.bottom.equalTo(weekView.snp.top)
		}

		whenEmptyView.snp.makeConstraints { make in
			make.right.left.top.equalToSuperview()
			make.bottom.equalTo(weekView.snp.top)
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
		weekView.register(DateCell.self, forCellWithReuseIdentifier: "dateCell")
		weekView.cellSize = UIScreen.main.bounds.width / 7

		weekView.scrollDirection = .horizontal
		weekView.scrollingMode = .stopAtEachCalendarFrame
		weekView.showsHorizontalScrollIndicator = false
	}

	func configureCell(view: JTACDayCell?, cellState: CellState) {
		guard let view = view as? DateCell else { return }
		view.backgroundColor = .grayColor
		view.numberText = cellState.text
		switch cellState.day {
		case .monday:
			view.dayText = "Пн"
		case .tuesday:
			view.dayText = "Вт"
		case .wednesday:
			view.dayText = "Ср"
		case .thursday:
			view.dayText = "Чт"
		case .friday:
			view.dayText = "Пт"
		case .saturday:
			view.dayText = "Сб"
		case .sunday:
			view.dayText = "Вс"
		}
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
// swiftlint:disable force_unwrapping vertical_parameter_alignment force_cast
extension ScheduleScreenViewController: JTACMonthViewDataSource {
	public func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy MM dd"
		let startDate = formatter.date(from: "2022 09 19")!
		let endDate = formatter.date(from: "2022 09 25")!
		return ConfigurationParameters(startDate: startDate,
									   endDate: endDate,
									   numberOfRows: 1,
									   generateInDates: .forFirstMonthOnly,
									   generateOutDates: .tillEndOfRow,
									   hasStrictBoundaries: false)
	}
}

extension ScheduleScreenViewController: JTACMonthViewDelegate {
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
		let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
		self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
		return cell
	}

	public func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
		print(date)
		print(cellState)
	}
}

class DateCell: JTACDayCell {
	private let number = UILabel()
	private let day = UILabel()

	var numberText: String {
		get {
			number.text ?? ""
		}
		set {
			number.text = newValue
		}
	}

	var dayText: String {
		get {
			day.text ?? ""
		}
		set {
			day.text = newValue
		}
	}

	override init(frame: CGRect) {
		super.init(frame: frame)

		setupViews()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func setupViews() {
		addSubview(number)
		addSubview(day)

		number.textAlignment = .center
		number.snp.makeConstraints { make in
			make.right.top.left.equalToSuperview()
			make.height.equalTo(30)
		}

		day.textAlignment = .center
		day.snp.makeConstraints { make in
			make.right.bottom.left.equalToSuperview()
			make.top.equalTo(number.snp.bottom)
		}
	}
}
