//
//  RegistrationScreenInterfaces.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 24.10.2022.
//

import UIKit

protocol RegistrationScreenWireframeInterface: WireframeInterface {
    func navigateToMain()
}

protocol RegistrationScreenViewInterface: ViewInterface {}

protocol RegistrationScreenPresenterInterface: PresenterInterface {
    func login()
}

protocol RegistrationScreenInteractorInterface: InteractorInterface {
    func login() async throws -> UserModel
}
