import Foundation
import UIKit

class NewCourseAssembly {
    static func build(
        moduleOutput: NewCourseModuleOutput?
    ) -> (UIViewController, NewCourseModuleInput) {
        let view = NewCourseViewController()
        let presenter = NewCoursePresenter()
        presenter.output = moduleOutput
        presenter.view = view
        view.output = presenter
        return (view, presenter)
    }
}
