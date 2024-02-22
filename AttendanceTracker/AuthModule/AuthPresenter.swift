//
//  AuthPresenter.swift
//  AttendanceTracker
//
//  Created by Настя Лазарева on 21.02.2024.
//

import Foundation

public protocol AuthModuleInput {
    
}

public protocol AuthViewOutput {
    
}

class AuthPresenter {
    weak var view: AuthViewInput?

    var output: AuthModuleOutput?
}

extension AuthPresenter: AuthModuleInput {
    
}

extension AuthPresenter: AuthViewOutput {
    
}

