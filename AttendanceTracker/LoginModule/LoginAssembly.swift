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
        moduleOutput: LoginModuleOutput?
    ) -> (UIViewController, LoginModuleInput) {
        let view = LoginViewController()
        let presenter = LoginPresenter()
        presenter.output = moduleOutput
        presenter.view = view
        view.output = presenter
        return (view, presenter)
    }
}
