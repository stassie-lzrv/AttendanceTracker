//
//  LoginAssembly.swift
//  AttendanceTracker
//
//  Created by Anastasia Lazareva on 23.02.2024.
//

import Foundation
import UIKit

class LoginAssembly {
    static func build(
        moduleOutput: LoginModuleOutput?,
        type: LoginView.LoginType
    ) -> (UIViewController, LoginModuleInput) {
        let view = LoginViewController()
        let presenter = LoginPresenter()
        presenter.output = moduleOutput
        presenter.loginType = type
        presenter.view = view
        view.output = presenter
        return (view, presenter)
    }
}
