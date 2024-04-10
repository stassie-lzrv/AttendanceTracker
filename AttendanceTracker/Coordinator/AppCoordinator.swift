import Foundation
import UIKit

struct Context {
    var token: String
    var user: User
    
    var courses: String
}

class AppCoordinator: Coordinator {
    private let apiService = APIServiceImpl()
    
    private var navigationController: UINavigationController?
    private var context: Context?

    private var authModuleInput: AuthModuleInput?
    private var loginModuleInput: LoginModuleInput?
    private var mainModuleInput: MainModuleInput?
    private var newCourseModuleInput: NewCourseModuleInput?
    private var courseListModuleInput: CourseListModuleInput?
    private var profileModuleInput: ProfileModuleInput?
    private var qrModuleInput: QRModuleInput?
    private var statisticsModuleInput: StatisticsModuleInput?
    private var statisticsModuleInputByClass: StatisticsModuleInput?
    private var statisticsModuleInputByStudent: StatisticsModuleInput?

    func build() -> UINavigationController? {
        buildEntryPoint()
        return navigationController
    }
}

private extension AppCoordinator {
    
    func buildEntryPoint() {
        let module = AuthAssembly.build(moduleOutput: self)
        authModuleInput = module.1
        
        self.navigationController = UINavigationController(rootViewController: module.0)
    }
    
}

extension AppCoordinator: AuthModuleOutput {
    func navigateToRegistration() {
        let module = LoginAssembly.build(moduleOutput: self, apiService: apiService, type: .registration)
        loginModuleInput = module.1

        self.navigationController?.pushViewController(module.0, animated: true)
    }

    func navigateToLogin() {
        let module = LoginAssembly.build(moduleOutput: self, apiService: apiService, type: .login)
        loginModuleInput = module.1

        self.navigationController?.pushViewController(module.0, animated: true)
    }
}

extension AppCoordinator: LoginModuleOutput {
    func continueWithRegistration(_ token: AuthResponce) {
        context?.token = token.token
        let module = MainAssembly.build(moduleOutput: self, apiService: apiService, token: token.token)
        mainModuleInput = module.1
        
        self.navigationController?.pushViewController(module.0, animated: true)
    }
    
    func continueWithLogin(_ token: AuthResponce) {
        context?.token = token.token
        let module = MainAssembly.build(moduleOutput: self, apiService: apiService, token: token.token)
        mainModuleInput = module.1
        
        self.navigationController?.pushViewController(module.0, animated: true)
    }
    
    func showError() {}
}

extension AppCoordinator: MainModuleOutput {
    func showCourseList() {
        guard let token = context?.token else {
            showError()
            return
        }
        let module = CourseListAssembly.build(moduleOutput: self, token: token, apiService: apiService)
        courseListModuleInput = module.1

        self.navigationController?.pushViewController(module.0, animated: true)
    }
    
    func navigateToProfile(_ user: User) {
        context?.user = user
        guard let token = context?.token else {
            showError()
            return
        }
        
        let module = ProfileAssembly.build(moduleOutput: self, token: token, apiService: apiService, user: user)
        profileModuleInput = module.1

        self.navigationController?.pushViewController(module.0, animated: true)
    }
    
    func navigateToQR() {
        guard let token = context?.token else {
            showError()
            return
        }
        let module = QRAssembly.build(moduleOutput: self, token: token, apiService: apiService)
        qrModuleInput = module.1

        self.navigationController?.pushViewController(module.0, animated: true)
    }

}

extension AppCoordinator: NewCourseModuleOutput {

}

extension AppCoordinator: CourseListModuleOutput {
    func showAddCourseScreen() {
        let module = NewCourseAssembly.build(moduleOutput: self)
        newCourseModuleInput = module.1

        self.navigationController?.pushViewController(module.0, animated: true)
    }
    
    func showDetailedStatistics(for courseId: String) {
        guard let token = context?.token,
              let userType = context?.user.userType
        else {
            showError()
            return
        }
        let module = StatisticsAssembly.build(moduleOutput: self, token: token, apiService: apiService, courseId: courseId, userType: userType, classId: nil, studentId: nil)
        statisticsModuleInput = module.1

        self.navigationController?.pushViewController(module.0, animated: true)
    }
}

extension AppCoordinator: ProfileModuleOutput {
    func userInfoChanged(_ newUser: User) {
        context?.user = newUser
    }
}

extension AppCoordinator: QRModuleOutput {
    
}

extension AppCoordinator: StatisticsModuleOutput {
    func showDetailStatictics(courseId: String, classId: String, studentId: String?) {
        guard let token = context?.token,
              let userType = context?.user.userType
        else {
            showError()
            return
        }
        if let studentId {
            let module = StatisticsAssembly.build(moduleOutput: self, token: token, apiService: apiService, courseId: courseId, userType: userType, classId: classId, studentId: studentId)
            statisticsModuleInputByStudent = module.1

            self.navigationController?.pushViewController(module.0, animated: true)
        } else {
            let module = StatisticsAssembly.build(moduleOutput: self, token: token, apiService: apiService, courseId: courseId, userType: userType, classId: classId, studentId: nil)
            statisticsModuleInputByClass = module.1

            self.navigationController?.pushViewController(module.0, animated: true)
        }
    }
    
}
