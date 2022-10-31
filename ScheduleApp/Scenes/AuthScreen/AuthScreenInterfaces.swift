//
//  AuthScreenInterfaces.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 24.10.2022.
//

import UIKit

protocol AuthScreenWireframeInterface: WireframeInterface {
    func navigateToMain()
}

protocol AuthScreenViewInterface: ViewInterface {}

protocol AuthScreenPresenterInterface: PresenterInterface {
    func signIn(withUsername username: String, password: String)
    func signUp(_ user: CreateUserModel)
}

protocol AuthScreenInteractorInterface: InteractorInterface {
    func signIn(withUsername username: String, password: String) async throws -> UserModel
    func signUp(_ user: CreateUserModel) async throws -> UserModel
}
