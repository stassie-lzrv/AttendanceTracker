import Foundation
import UIKit

public final class MainTextField: UIView {

    public struct ViewModel {
        let placeHolder: String?
        let text: String?
        let rightSystemImageName: String?
        let leftSystemImageName: String?

        init(
            placeHolder: String? = nil,
            text: String? = nil,
            rightSystemImageName: String? = nil,
            leftSystemImageName: String? = nil
        ) {
            self.placeHolder = placeHolder
            self.text = text
            self.rightSystemImageName = rightSystemImageName
            self.leftSystemImageName = leftSystemImageName
        }
    }

    private let textField = UITextField()

    private var rigthImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = ColorPallete.labelSecondary
        return imageView
    }()
    
    private var leftImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = ColorPallete.labelSecondary
        return imageView
    }()

    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 10
        return stack
    }()

    private var viewModel: ViewModel? {
        didSet {
            updateView()
        }
    }

    public func set(_ viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    public func getText() -> String? {
        return textField.text
    }

    private func updateView() {
        guard let viewModel else { return }
        textField.placeholder = viewModel.placeHolder
        if let text = viewModel.text {
            textField.text = text
        }
        if let rightSystemImageName = viewModel.rightSystemImageName {
            let image = UIImage(systemName: rightSystemImageName)
            rigthImageView.image = image
            rigthImageView.isHidden = false
        } else {
            rigthImageView.isHidden = true
        }
        
        if let leftSystemImageName = viewModel.leftSystemImageName {
            let image = UIImage(systemName: leftSystemImageName)
            leftImageView.image = image
            leftImageView.isHidden = false
        } else {
            leftImageView.isHidden = true
        }
        setNeedsLayout()
    }

    public override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = ColorPallete.backgroundSecondary
        layer.cornerRadius = 12
        setupSubviews()
        applyLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(rigthImageView)
        mainStackView.addArrangedSubview(textField)
        mainStackView.addArrangedSubview(leftImageView)
    }

    private func applyLayout() {
        [rigthImageView, mainStackView, leftImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        addToEdges(subview: mainStackView, left: 10, right: -10)
        NSLayoutConstraint.activate([
            rigthImageView.heightAnchor.constraint(equalToConstant: 25),
            rigthImageView.widthAnchor.constraint(equalToConstant: 25),
            
            leftImageView.heightAnchor.constraint(equalToConstant: 25),
            leftImageView.widthAnchor.constraint(equalToConstant: 25)
        ])
    }
}
