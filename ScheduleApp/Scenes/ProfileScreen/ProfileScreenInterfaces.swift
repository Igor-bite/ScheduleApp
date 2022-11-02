//
//  ProfileScreenInterfaces.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 31.10.2022.
//

import UIKit

protocol ProfileScreenWireframeInterface: WireframeInterface {
    func showPasswordChangeScreen()
    func showUserCreatorScreen()
}

protocol ProfileScreenViewInterface: ViewInterface {}

protocol ProfileScreenPresenterInterface: PresenterInterface {
    var currentUser: UserModel? { get }
    var shouldShowCreateButton: Bool { get }

    func saveChanges(firstName: String, secondName: String, lastName: String, birthday: Date)
    func changePassword()
    func removeAccount()
    func logout()
    func createNewUser()
}

protocol ProfileScreenInteractorInterface: InteractorInterface {
    func createNewUser(user: CreateUserModel) async throws -> UserModel
    func update(user: UpdateUserModel) async throws -> UserModel
    func removeAccount(user: UserModel?) async throws
    func logout()
}
