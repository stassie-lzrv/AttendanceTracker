import Foundation
import UIKit

public protocol AuthViewControllerDelegate: AnyObject {
    func startRegistration()
    func startLogin()
}
public final class AuthView: UIView {

    weak var delegate: AuthViewControllerDelegate?

    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.contentMode = .scaleAspectFit
        stack.spacing = 10
        return stack
    }()

    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .bold)
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

    private let registrationButton = MainButton()
    
    private let loginButton = MainButton()
    
    func configure() {
        setupSubviews()
        applyLayout()
        setButtonViewModels()
    }
    
    private func setupSubviews() {
        addSubview(appNameLabel)
        addSubview(mainIcon)
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(registrationButton)
        mainStackView.addArrangedSubview(loginButton)
    }
    
    private func applyLayout() {
        backgroundColor = ColorPallet.backgroundPrimary
        [appNameLabel, mainIcon, mainStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            appNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.topInset),
            appNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            mainIcon.widthAnchor.constraint(equalToConstant: 100),
            mainIcon.heightAnchor.constraint(equalToConstant: 100),
            mainIcon.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: 30),
            mainIcon.centerXAnchor.constraint(equalTo: centerXAnchor),


            mainStackView.topAnchor.constraint(equalTo: mainIcon.bottomAnchor, constant: 50),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalInset),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalInset),
            
            registrationButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setButtonViewModels() {
        registrationButton.set(
            MainButton.ViewModel(
                title: "Регистрация",
                systemImageName: "envelope",
                action: { [weak self] in
                    self?.delegate?.startRegistration()
                }
            )
        )

        loginButton.set(
            MainButton.ViewModel(
                title: "Вход",
                systemImageName: "magnifyingglass",
                action: { [weak self] in
                    self?.delegate?.startLogin()
                }
            )
        )
    }
}

extension AuthView {
    enum Constants {
        static let topInset: CGFloat = 200
        static let horizontalInset: CGFloat = 60
    }
}
