//
//  PasswordChangeScreenInterfaces.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 01.11.2022.
//

import UIKit

protocol PasswordChangeScreenWireframeInterface: WireframeInterface {}

protocol PasswordChangeScreenViewInterface: ViewInterface {}

protocol PasswordChangeScreenPresenterInterface: PresenterInterface {
    func validateCurrentPassword(pass: String) -> Bool
    func changePassword(new: String)
}

protocol PasswordChangeScreenInteractorInterface: InteractorInterface {
    func update(user: UpdateUserModel) async throws -> UserModel
}
