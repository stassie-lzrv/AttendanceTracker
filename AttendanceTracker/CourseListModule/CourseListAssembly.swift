import Foundation
import UIKit

struct CourseListAssembly {
    static func build(
        moduleOutput: CourseListModuleOutput?,
        token: String,
        apiService: APIService
    ) -> (UIViewController, CourseListModuleInput) {
        let view = CourseListViewController()
        let presenter = CourseListPresenter(token: token, apiService: apiService)
        presenter.output = moduleOutput
        presenter.view = view
        view.output = presenter
        return (view, presenter)
    }
}

