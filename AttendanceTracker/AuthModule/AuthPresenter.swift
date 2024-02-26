//
//  AuthPresenter.swift
//  AttendanceTracker
//
//  Created by Настя Лазарева on 21.02.2024.
//

import Foundation

public protocol AuthModuleInput {
    
}

public protocol AuthViewOutput {
    func showRegistrationScreen()
    func showLoginScreen()
}

class AuthPresenter {
    weak var view: AuthViewInput?

    var output: AuthModuleOutput?
}

extension AuthPresenter: AuthModuleInput {
    
}

extension AuthPresenter: AuthViewOutput {
    func showRegistrationScreen() {
        output?.navigateToRegistration()
    }

    func showLoginScreen() {
        output?.navigateToLogin()
    }
}

