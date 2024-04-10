import Foundation
import UIKit

enum QRAssembly {
    static func build(
        moduleOutput: QRModuleOutput?,
        token: String,
        apiService: APIService
    ) -> (UIViewController, QRModuleInput) {
        let view = QRViewController()
        let presenter = QRPresenter(token: token, apiService: apiService)
        presenter.output = moduleOutput
        presenter.view = view
        view.output = presenter
        return (view, presenter)
    }
}

