import Foundation
import UIKit

public protocol ProfileViewControllerDelegate: AnyObject {
    func saveButtonTapped(name: String, email: String)

}

public protocol ProfileViewDelegate {
    func configure(name: String, email: String)
}

public final class ProfileView: UIView {

    weak var delegate: ProfileViewControllerDelegate?
    
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 30
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let titleStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.text = "Настройки профиля"
        label.textColor = ColorPallete.labelPrimary
        return label
    }()
    
    let editButton: UIButton = {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .default)
        let image = UIImage(systemName: "pencil")?.applyingSymbolConfiguration(largeConfig)
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.tintColor = ColorPallete.labelSecondary
        return button
    }()
    
    let languageStackView : UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let languageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.text = "Язык приложения"
        label.textColor = ColorPallete.labelPrimary
        return label
    }()
    
    let segmentControl: UISegmentedControl = {
        let items = ["English", "Русский"]
        let segment = UISegmentedControl(items: items)
        segment.selectedSegmentIndex = 1
        return segment
    }()
    
    let saveButton = MainButton()
    
    private let nameTextField = MainTextField()
    private let emailTextField = MainTextField()
    
    func configure() {
        setupSubviews()
        applyLayout()
        
        segmentControl.addTarget(self, action: #selector(languageChanged), for: .valueChanged)
        editButton.addTarget(self, action: #selector(enableEditing), for: .touchUpInside)
        saveButton.set(MainButton.ViewModel(title: "Сохранить", titleColor: ColorPallete.accentColor, action: { [weak self] in
            guard let sSelf = self,
                  let name = sSelf.nameTextField.getText(),
                  let email = sSelf.emailTextField.getText()
            else { return }
            sSelf.delegate?.saveButtonTapped(name: name, email: email)
        }))
    }
    
    private func setupSubviews() {
        addSubview(mainStackView)
        [titleLabel, editButton].forEach {
            titleStackView.addArrangedSubview($0)
        }
        
        [languageLabel, segmentControl].forEach {
            languageStackView.addArrangedSubview($0)
        }
        
        [titleStackView, nameTextField, emailTextField, languageStackView, saveButton].forEach {
            mainStackView.addArrangedSubview($0)
        }
        
        nameTextField.isUserInteractionEnabled = false
        emailTextField.isUserInteractionEnabled = false
    }
    
    private func applyLayout() {
        backgroundColor = UIColor(patternImage: UIImage(named: "background_light") ?? UIImage())
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 15),
            mainStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant:  -15),
            mainStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            
            nameTextField.heightAnchor.constraint(equalToConstant: 50),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            saveButton.heightAnchor.constraint(equalToConstant: 60)
           
        ])
    }
    
    @objc
    private func enableEditing() {
        nameTextField.isUserInteractionEnabled = true
        emailTextField.isUserInteractionEnabled = true
    }
    
    @objc
    private func languageChanged() {
        if segmentControl.selectedSegmentIndex == 0 {
            titleLabel.text = "Profile settings"
            languageLabel.text = "App language"
            saveButton.set(MainButton.ViewModel(title: "Save", titleColor: ColorPallete.accentColor))
        } else {
            titleLabel.text = "Настройки профиля"
            languageLabel.text = "Язык приложения"
            saveButton.set(MainButton.ViewModel(title: "Сохранить", titleColor: ColorPallete.accentColor))
        }
    }
}

extension ProfileView: ProfileViewDelegate {
    public func configure(name: String, email: String) {
        nameTextField.set(MainTextField.ViewModel(text: name))
        emailTextField.set(MainTextField.ViewModel(text: email))
    }
}
