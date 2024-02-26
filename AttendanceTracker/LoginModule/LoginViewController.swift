//
//  LoginViewController.swift
//  AttendanceTracker
//
//  Created by Anastasia Lazareva on 23.02.2024.
//

import Foundation
import UIKit

public protocol LoginViewInput: AnyObject {
}

final class LoginViewController: UIViewController {
    var output: LoginViewOutput?

    override func viewDidLoad() {
        super.viewDidLoad()
        let customView = LoginView()
        customView.configure(type: .registration)
        customView.delegate = self
        view = customView

        navigationItem.hidesBackButton = true
        if let image = UIImage(systemName: "chevron.backward")?.withTintColor(.black) {
            let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backButtonTapped))
            self.navigationItem.leftBarButtonItem = button
        }
    }

    @objc
    func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }


}

extension LoginViewController: LoginViewInput {

}

extension LoginViewController: LoginViewControllerDelegate {
    func continueWithRegistration() {
        output?.continueWithRegistration()
    }

    func continueWithLogin() {
        output?.continueWithLogin()
    }

}
