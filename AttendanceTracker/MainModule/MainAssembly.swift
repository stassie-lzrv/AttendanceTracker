import Foundation
import UIKit

class MainAssembly {
    static func build(
        moduleOutput: MainModuleOutput?,
        apiService: APIService,
        token: String
    ) -> (UIViewController, MainModuleInput) {
        let view = MainViewController()
        let presenter = MainPresenter(token: token, apiService: apiService)
        presenter.output = moduleOutput
        presenter.view = view
        view.output = presenter
        return (view, presenter)
    }
}
