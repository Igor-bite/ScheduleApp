//
//  CoursesCreatorScreenViewController.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 27.09.2022.
//

import UIKit

public final class CoursesCreatorScreenViewController: UIViewController {
	enum Constants {
		static let submitButtonHeight = 48
		static let gapHeight = 10
		static let sideOffset = 16
		static let sectionHeight = 44
		static let twoThirdsSections = sectionHeight / 3 * 2
	}

	private let labelView: UILabel = {
		let view = UILabel.titleLabel
		view.text = "Новый курс"
		return view
	}()

	private let contentView: UIView = {
		let view = UIView()
		view.layer.cornerRadius = 14
		view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
		view.backgroundColor = .Pallette.mainBgColor
		return view
	}()

	private let courseTypeSegmentedControl = UISegmentedControl(items: ["Оффлайн", "Онлайн"])

	private let titleEnterInput = {
		let textField = UITextField()
		textField.placeholder = "Название курса"
		return textField
	}()

	private let descriptionEnterInput = {
		let textField = UITextField()
		textField.placeholder = "Описание курса"
		return textField
	}()

//	private let studentCount

	private let submitButton: UIButton = {
		let button = UIButton.barButton
		button.setTitle("Создать", for: .normal)
		button.layer.cornerRadius = 15
		button.addTarget(self, action: #selector(createCourse), for: .touchUpInside)
		return button
	}()

    // MARK: - Public properties -

    // swiftlint:disable:next implicitly_unwrapped_optional
    var presenter: CoursesCreatorScreenPresenterInterface!

    // MARK: - Lifecycle -

    public override func viewDidLoad() {
        super.viewDidLoad()

		setupViews()
    }

	public override func viewDidAppear(_ animated: Bool) {
		titleEnterInput.becomeFirstResponder()
	}

	private func setupViews() {
		traceKeyboard()
		hideKeyboardOnTap()
		view.backgroundColor = .clear

		view.addSubview(contentView)
		contentView.addSubview(labelView)
		contentView.addSubview(courseTypeSegmentedControl)
		contentView.addSubview(titleEnterInput)
		contentView.addSubview(submitButton)

		contentView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.bottom.equalToSuperview()
			make.top.equalTo(labelView.snp.top).offset(-Constants.gapHeight)
		}

		labelView.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(Constants.sideOffset)
			make.trailing.equalToSuperview().inset(Constants.sideOffset)
			make.height.equalTo(Constants.sectionHeight)
			make.bottom.equalTo(courseTypeSegmentedControl.snp.top).offset(-Constants.gapHeight)
		}

		courseTypeSegmentedControl.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(Constants.sideOffset)
			make.trailing.equalToSuperview().inset(Constants.sideOffset)
			make.height.equalTo(Constants.twoThirdsSections)
			make.bottom.equalTo(titleEnterInput.snp.top).offset(-Constants.gapHeight)
		}

		titleEnterInput.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(Constants.sideOffset)
			make.trailing.equalToSuperview().inset(Constants.sideOffset)
			make.height.equalTo(Constants.sectionHeight)
			make.bottom.equalTo(submitButton.snp.top).offset(-Constants.gapHeight)
		}

		submitButton.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(Constants.sideOffset)
			make.trailing.equalToSuperview().inset(Constants.sideOffset)
			make.height.equalTo(Constants.sectionHeight)
			make.bottom.equalTo(contentView.snp.bottom).inset(Constants.gapHeight + Int(UIApplication.shared.windows.first!.safeAreaInsets.bottom))
		}

		courseTypeSegmentedControl.selectedSegmentIndex = 0
		courseTypeSegmentedControl.addTarget(self, action: #selector(self.segmentedValueChanged), for: .valueChanged)
	}

	@objc
	func segmentedValueChanged() {
		print("Selected Segment Index is : \(courseTypeSegmentedControl.selectedSegmentIndex)")
	}

	@objc
	private func createCourse() {
//		if let taskName = titleEnterInput.text,
//		   taskName != "" {
//
//			guard let statusIndex = statusPicker.selectedValueIndexes[safe: 0] else { return }
//			let userIndexes = usersPicker.selectedValueIndexes
//
//			tasksInput?.addTask(taskName: taskName, statusIndex: statusIndex, userIndexes: userIndexes)
//			self.dismiss(animated: true, completion: nil)
//		} else {
//			titleEnterInput.alert()
//			return
//		}
	}
}

// MARK: - Extensions -

extension CoursesCreatorScreenViewController: CoursesCreatorScreenViewInterface {
}
