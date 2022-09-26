//
//  SplashScreenWireframe.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 26.09.2022.
//

import UIKit

public final class SplashScreenWireframe: BaseWireframe<SplashScreenViewController> {

    // MARK: - Private properties -

	private let dismiss: () -> Void

    // MARK: - Module setup -

	public init(dismiss: @escaping () -> Void) {
		self.dismiss = dismiss
        let moduleViewController = SplashScreenViewController()
        super.init(viewController: moduleViewController)

        let presenter = SplashScreenPresenter(view: moduleViewController, wireframe: self)
        moduleViewController.presenter = presenter
    }

}

// MARK: - Extensions -

extension SplashScreenWireframe: SplashScreenWireframeInterface {
	public func dismissSplash() {
		self.dismiss()
	}
}
