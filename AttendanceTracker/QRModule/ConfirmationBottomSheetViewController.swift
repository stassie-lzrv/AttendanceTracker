import UIKit
import Foundation

protocol ConfirmationDelegate: AnyObject {
    func didTapDone(inputCode: String)
}

class ConfirmationBottomSheetViewController: UIViewController {
    
    weak var delegate: ConfirmationDelegate?
    
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 30
        return stack
    }()
    
    let codeLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = ColorPallete.labelPrimary
        return label
    }()
    
    let saveButton: MainButton = {
        let button = MainButton()
        return button
    }()
    
    private let codeTextField = MainTextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        setupSubviews()
        applyLayout()
    }
    
    private func setupSubviews() {
        codeTextField.set(MainTextField.ViewModel(placeHolder: "Введите код, написанный выше"))
        view.addSubview(mainStackView)
        [codeLabel, codeTextField, saveButton].forEach {
            mainStackView.addArrangedSubview($0)
        }
        
        saveButton.set(MainButton.ViewModel(title: "Готово", titleColor: ColorPallete.accentColor, action: { [self] in
            guard let input = self.codeTextField.getText() else { return }
            self.dismiss(animated: false)
            delegate?.didTapDone(inputCode: input)
        }))
        
    }
    
    private func applyLayout() {
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background_dark") ?? UIImage())
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant:  -30),
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200),
            
            codeTextField.heightAnchor.constraint(equalToConstant: 50),
            saveButton.heightAnchor.constraint(equalToConstant: 60),
            saveButton.widthAnchor.constraint(equalToConstant: 200)
           
        ])
    }
}

