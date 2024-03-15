import Foundation
import UIKit

struct Context {
    var userInfo: String
    var courses: String
    
}

class AppCoordinator: Coordinator {
    
    var navigationController: UINavigationController?
    var context: Context?

    var authModuleInput: AuthModuleInput?
    var loginModuleInput: LoginModuleInput?
    var mainModuleInput: MainModuleInput?
    var newCourseModuleInput: NewCourseModuleInput?

    func build() -> UINavigationController? {
        buildEntryPoint()
        return navigationController
    }
    
    var mapsModuleVC: UIViewController?
}

private extension AppCoordinator {
    
    func buildEntryPoint() {
        let module = AuthAssembly.build(moduleOutput: self)
        authModuleInput = module.1
        
        self.navigationController = UINavigationController(rootViewController: module.0)

        let mainModule = NewCourseAssembly.build(moduleOutput: self)
        newCourseModuleInput = mainModule.1

        self.navigationController?.pushViewController(mainModule.0, animated: true)

    }
    
}

extension AppCoordinator: AuthModuleOutput {
    func navigateToRegistration() {
        let module = LoginAssembly.build(moduleOutput: self, type: .registration)
        loginModuleInput = module.1

        self.navigationController?.pushViewController(module.0, animated: true)
    }

    func navigateToLogin() {
        let module = LoginAssembly.build(moduleOutput: self, type: .login)
        loginModuleInput = module.1

        self.navigationController?.pushViewController(module.0, animated: true)
    }
}

extension AppCoordinator: LoginModuleOutput {

}

extension AppCoordinator: MainModuleOutput {


}

extension AppCoordinator: NewCourseModuleOutput {

}
