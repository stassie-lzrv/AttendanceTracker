import Foundation
import UIKit

public protocol LoginViewInput: AnyObject { }

final class LoginViewController: UIViewController {
    var output: LoginViewOutput?
    var viewDelegate: LoginViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        let customView = LoginView()
        customView.configure(type: output?.loginType ?? .registration)
        customView.delegate = self
        viewDelegate = customView
        view = customView

        navigationItem.hidesBackButton = true
        if let image = UIImage(systemName: "chevron.backward")?.withTintColor(.black) {
            let sizeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .default)
            let button = UIBarButtonItem(image: image.applyingSymbolConfiguration(sizeConfig), style: .plain, target: self, action: #selector(backButtonTapped))
            self.navigationItem.leftBarButtonItem = button
        }
    }

    @objc
    func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }

}

extension LoginViewController: LoginViewControllerDelegate, LoginViewInput {
    func continueWithRegistration() {
        guard let name = viewDelegate?.getName(),
              let email = viewDelegate?.getEmail(),
              let password = viewDelegate?.getPassword()
        else { return }
        output?.continueWithRegistration(name, email, password)
    }

    func continueWithLogin() {
        guard let email = viewDelegate?.getEmail(),
              let password = viewDelegate?.getPassword()
        else { return }
        output?.continueWithLogin(email, password)
    }

}
