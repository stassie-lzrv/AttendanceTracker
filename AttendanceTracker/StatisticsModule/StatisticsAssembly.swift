import Foundation
import UIKit

struct StatisticsAssembly {
    
    static func build(
        moduleOutput: StatisticsModuleOutput?,
        token: String,
        apiService: APIService,
        courseId: String,
        userType: UserType,
        classId: String?,
        studentId: String?
    ) -> (UIViewController, StatisticsModuleInput) {
        let view = StatisticsViewController()
        let presenter = StatisticsPresenter(token: token, apiService: apiService, courseId: courseId, userType: userType, classId: classId, studentId: studentId)
        presenter.output = moduleOutput
        presenter.view = view
        view.output = presenter
        return (view, presenter)
    }
}

