//
//  MainScreenViewController.swift
//  Core
//
//  Created by Игорь Клюжев on 15.09.2022.
//

import UIKit
import Reusable
import SnapKit

public final class MainScreenViewController: UIViewController {

	private lazy var table: UITableView = {
		let table = UITableView()
		table.showsVerticalScrollIndicator = false
		table.rowHeight = 60
		table.delegate = self
		table.dataSource = self
		table.register(cellType: MainScreenTableViewCell.self)
		return table
	}()

    // MARK: - Public properties -

    // swiftlint:disable:next implicitly_unwrapped_optional
    var presenter: MainScreenPresenterInterface!

    // MARK: - Lifecycle -

    public override func viewDidLoad() {
        super.viewDidLoad()

		setupViews()
		presenter.loadLessons()
    }

	private func setupViews() {
		view.addSubview(table)

		table.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
	}
}

// MARK: - Extensions -

extension MainScreenViewController: MainScreenViewInterface {
	public func reloadData() {
		DispatchQueue.main.async { [weak self] in
			self?.table.reloadData()
		}
	}
}

extension MainScreenViewController: UITableViewDataSource {
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		presenter.numberOfItems
	}

	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: MainScreenTableViewCell = tableView.dequeueReusableCell(for: indexPath)
		let lesson = presenter.item(at: indexPath)
		cell.configure(with: lesson)
		return cell
	}
}

extension MainScreenViewController: UITableViewDelegate {
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		presenter.itemSelected(at: indexPath)
	}
}
