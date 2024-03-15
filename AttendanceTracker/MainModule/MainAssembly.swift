import Foundation
import UIKit

class MainAssembly {
    static func build(
        moduleOutput: MainModuleOutput?
    ) -> (UIViewController, MainModuleInput) {
        let view = MainViewController()
        let presenter = MainPresenter()
        presenter.output = moduleOutput
        presenter.view = view
        view.output = presenter
        return (view, presenter)
    }
}
