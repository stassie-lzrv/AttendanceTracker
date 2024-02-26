//
//  AuthViewController.swift
//  AttendanceTracker
//
//  Created by Настя Лазарева on 21.02.2024.
//

import Foundation
import UIKit

public protocol AuthViewInput: AnyObject {
}

final class AuthViewController: UIViewController {
    var output: AuthViewOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let customView = AuthView()
        customView.configure()
        customView.delegate = self
        view = customView
    }
    
}

extension AuthViewController: AuthViewInput {
    
}

extension AuthViewController: AuthViewControllerDelegate {
    func startRegistration() {
        output?.showRegistrationScreen()
    }

    func startLogin() {
        output?.showLoginScreen()
    }
}
