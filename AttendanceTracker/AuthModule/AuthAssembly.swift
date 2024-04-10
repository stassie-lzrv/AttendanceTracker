import Foundation
import UIKit

enum AuthAssembly {
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

