import Foundation
import UIKit

public final class MainButton: UIButton {
    public struct ViewModel {
        let title: String
        let titleColor: UIColor
        let subtitle: String?
        let systemImageName: String?
        let action: (() -> Void)?
        
        init(
            title: String,
            titleColor: UIColor = ColorPallete.labelSecondary,
            subtitle: String? = nil,
            systemImageName: String? = nil,
            action: (() -> Void)? = nil
        ) {
            self.title = title
            self.titleColor = titleColor
            self.subtitle = subtitle
            self.systemImageName = systemImageName
            self.action = action
        }
    }

    private var viewModel: ViewModel? {
        didSet {
            updateView()
        }
    }
    
    private var rigthImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = ColorPallete.labelSecondary
        return imageView
    }()

    private let title: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = ColorPallete.labelSecondary
        label.textAlignment = .left
        return label
    }()
    
    private let subtitle: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = ColorPallete.labelSecondary
        return label
    }()
    
    private let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 10
        return stack
    }()
    
    private let verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
    
    public func set(_ viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    private func updateView() {
        guard let viewModel else { return }
        title.text = viewModel.title
        title.textColor = viewModel.titleColor
        rigthImageView.tintColor = viewModel.titleColor
        subtitle.text = viewModel.subtitle
        if let systemImageName = viewModel.systemImageName {
            let image = UIImage(systemName: systemImageName)
            rigthImageView.image = image
            rigthImageView.isHidden = false
            title.textAlignment = .left
        } else {
            rigthImageView.isHidden = true
            title.textAlignment = .center
        }
        setNeedsLayout()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(tapGesture)

        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = ColorPallete.backgroundSecondary
        layer.cornerRadius = 12
        setupSubviews()
        applyLayout()
    }

    @objc
    private func didTap() {
        viewModel?.action?()
    }

    private func setupSubviews() {
        mainStack.addArrangedSubview(rigthImageView)
        mainStack.addArrangedSubview(verticalStack)
        verticalStack.addArrangedSubview(title)
        verticalStack.addArrangedSubview(subtitle)
    }
    
    private func applyLayout() {
        addToEdges(subview: mainStack, left: 10, right: -10)

        NSLayoutConstraint.activate([
            rigthImageView.heightAnchor.constraint(equalToConstant: 25),
            rigthImageView.widthAnchor.constraint(equalToConstant: 25)
        ])
    }
    
}
