//
//  SplashScreenInterfaces.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 26.09.2022.
//

import UIKit

public protocol SplashScreenWireframeInterface: WireframeInterface {
	func dismissSplash()
}

public protocol SplashScreenViewInterface: ViewInterface {
}

public protocol SplashScreenPresenterInterface: PresenterInterface {
	func dismiss()
}
