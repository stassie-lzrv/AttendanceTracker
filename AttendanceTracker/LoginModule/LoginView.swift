//
//  LoginView.swift
//  AttendanceTracker
//
//  Created by Anastasia Lazareva on 23.02.2024.
//

import Foundation
import UIKit

public protocol LoginViewControllerDelegate: AnyObject {
    func continueWithRegistration()
    func continueWithLogin()

}
public final class LoginView: UIView {
    public enum LoginType {
        case login
        case registration
    }

    weak var delegate: LoginViewControllerDelegate?

    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.contentMode = .scaleAspectFit
        stack.spacing = 10
        return stack
    }()

    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.text = "Attendance Tracker"
        label.textColor = ColorPallet.accentColor
        return label
    }()

    private let mainIcon: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "mainIcon")
        imageView.image = image
        return imageView
    }()

    private let nameTextField = MainTextField()
    private let emailTextField = MainTextField()
    private let passwordTextField = MainTextField()
    private let continueButton = MainButton()


    func configure(type: LoginType) {
        setupSubviews()
        applyLayout()
        setButtonViewModels(type: type)
    }

    private func setupSubviews() {
        [appNameLabel, mainIcon, mainStackView, continueButton].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [nameTextField, emailTextField, passwordTextField].forEach {
            mainStackView.addArrangedSubview($0)
        }
    }

    private func applyLayout() {
        backgroundColor = ColorPallet.backgroundPrimary
        [appNameLabel, mainIcon, mainStackView, continueButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            appNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 100),
            appNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            mainIcon.widthAnchor.constraint(equalToConstant: 70),
            mainIcon.heightAnchor.constraint(equalToConstant: 70),
            mainIcon.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: 30),
            mainIcon.centerXAnchor.constraint(equalTo: centerXAnchor),


            mainStackView.topAnchor.constraint(equalTo: mainIcon.bottomAnchor, constant: 30),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),

            nameTextField.heightAnchor.constraint(equalToConstant: 50),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),

            continueButton.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 20),
            continueButton.heightAnchor.constraint(equalToConstant: 50),
            continueButton.widthAnchor.constraint(equalToConstant: 200),
            continueButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    private func setButtonViewModels(type: LoginType) {
        switch type {
            case .login:
                nameTextField.isHidden = true
            case .registration:
                break
        }
        nameTextField.set(
            MainTextField.ViewModel(placeHolder: "Имя Фамилия Отчество", systemImageName: "doc")
        )
        emailTextField.set(
            MainTextField.ViewModel(placeHolder: "Учебная почта", systemImageName: "envelope")
        )

        passwordTextField.set(
            MainTextField.ViewModel(placeHolder: "Пароль", systemImageName: "lock")
        )

        continueButton.set(
            MainButton.ViewModel(
                title: "Продолжить",
                titleColor: .white,
                action: { [weak self] in
                    switch type {
                        case .login:
                            self?.delegate?.continueWithLogin()
                        case .registration:
                            self?.delegate?.continueWithRegistration()
                    }
                }
            )
        )
        continueButton.backgroundColor = ColorPallet.accentColor
    }

}
