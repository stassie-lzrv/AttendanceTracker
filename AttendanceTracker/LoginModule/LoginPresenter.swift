//
//  LoginPresenter.swift
//  AttendanceTracker
//
//  Created by Anastasia Lazareva on 23.02.2024.
//

import Foundation

public protocol LoginModuleInput {

}

public protocol LoginViewOutput {
    func continueWithRegistration()
    func continueWithLogin()
}

class LoginPresenter {
    weak var view: LoginViewInput?

    var output: LoginModuleOutput?
}

extension LoginPresenter: LoginModuleInput {

}

extension LoginPresenter: LoginViewOutput {
    func continueWithRegistration() {
        print("continue with registration")
    }

    func continueWithLogin() {
        print("continue with login")
    }
}

