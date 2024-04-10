import Foundation
import UIKit

enum LoginAssembly {
    static func build(
        moduleOutput: LoginModuleOutput?,
        apiService: APIService,
        type: LoginView.LoginType
    ) -> (UIViewController, LoginModuleInput) {
        let view = LoginViewController()
        let presenter = LoginPresenter(loginType: type, apiService: apiService)
        presenter.output = moduleOutput
        presenter.view = view
        view.output = presenter
        return (view, presenter)
    }
}
