import Foundation
import UIKit

enum ProfileAssembly {
    static func build(
        moduleOutput: ProfileModuleOutput?,
        token: String,
        apiService: APIService,
        user: User
    ) -> (UIViewController, ProfileModuleInput) {
        let view = ProfileViewController()
        let presenter = ProfilePresenter(apiService: apiService, token: token, user: user)
        presenter.output = moduleOutput
        presenter.view = view
        view.output = presenter
        return (view, presenter)
    }
}

