//
//  UserCreatorScreenInterfaces.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 01.11.2022.
//

import UIKit

protocol UserCreatorScreenWireframeInterface: WireframeInterface {}

protocol UserCreatorScreenViewInterface: ViewInterface {}

protocol UserCreatorScreenPresenterInterface: PresenterInterface {
    func create(user: CreateUserModel)
}

protocol UserCreatorScreenInteractorInterface: InteractorInterface {
    func create(user: CreateUserModel) async throws
}
