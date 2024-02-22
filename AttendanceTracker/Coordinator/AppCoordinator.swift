//
//  AppCoordinator.swift
//  AttendanceTracker
//
//  Created by Настя Лазарева on 21.02.2024.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    
    var navigationController: UINavigationController?
    
    var authModuleInput: AuthModuleInput?
    
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
    }
    
}

extension AppCoordinator: AuthModuleOutput {

}
