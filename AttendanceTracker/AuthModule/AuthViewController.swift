import Foundation
import UIKit

public protocol AuthViewInput: AnyObject { }

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

extension AuthViewController: AuthViewControllerDelegate, AuthViewInput {
    func startRegistration() {
        output?.showRegistrationScreen()
    }

    func startLogin() {
        output?.showLoginScreen()
    }
}
