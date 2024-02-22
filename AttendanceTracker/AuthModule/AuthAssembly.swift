//
//  MainAssembly.swift
//  AttendanceTracker
//
//  Created by Настя Лазарева on 21.02.2024.
//

import Foundation
import UIKit

class AuthAssembly {
    static func build(
        moduleOutput: AuthModuleOutput?
    ) -> (UIViewController, AuthModuleInput) {
        let view = AuthViewController()
        let presenter = AuthPresenter()
        presenter.output = moduleOutput
        presenter.view = view
        view.output = presenter
        return (view, presenter)
    }
}

