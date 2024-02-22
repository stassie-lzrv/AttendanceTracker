//
//  AuthView.swift
//  AttendanceTracker
//
//  Created by Настя Лазарева on 21.02.2024.
//

import Foundation
import UIKit

public final class AuthView: UIView {

    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.contentMode = .scaleAspectFit
        stack.backgroundColor = .green
        stack.spacing = 10
        return stack
    }()
    
    private var registrationButton: MainButton = {
        let button = MainButton()
        button.set(MainButton.ViewModel(title: "Регистрация"))
        return button
    }()
    
    private var loginButton: MainButton = {
        let button = MainButton()
        button.set(MainButton.ViewModel(title: "Вход"))
        return button
    }()
    
    //weak var delegate: GeneralViewControllerDelegate?
    
    func configure() {
        setupSubviews()
        applyLayout()
    }
    
    private func setupSubviews() {
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(registrationButton)
        mainStackView.addArrangedSubview(loginButton)
    }
    
    private func applyLayout() {
        backgroundColor = ColorPallet.backgroundPrimary
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.topInset),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalInset),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalInset),
            
            registrationButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

extension AuthView {
    enum Constants {
        static let topInset: CGFloat = 300
        static let horizontalInset: CGFloat = 100
    }
}
