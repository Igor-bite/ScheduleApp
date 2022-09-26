//
//  SplashScreenPresenter.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 26.09.2022.
//

import UIKit

public final class SplashScreenPresenter {

    // MARK: - Private properties -

    private unowned let view: SplashScreenViewInterface
    private let wireframe: SplashScreenWireframeInterface

    // MARK: - Lifecycle -

    init(
        view: SplashScreenViewInterface,
        wireframe: SplashScreenWireframeInterface
    ) {
        self.view = view
        self.wireframe = wireframe
    }
}

// MARK: - Extensions -

extension SplashScreenPresenter: SplashScreenPresenterInterface {
	public func dismiss() {
		self.wireframe.dismissSplash()
	}
}
