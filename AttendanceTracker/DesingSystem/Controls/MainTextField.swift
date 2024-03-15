import Foundation
import UIKit

public final class MainTextField: UIView {

    public struct ViewModel {
        let placeHolder: String?
        let systemImageName: String?

        init(placeHolder: String?, systemImageName: String?) {
            self.placeHolder = placeHolder
            self.systemImageName = systemImageName
        }
    }

    private let textField = UITextField()

    private var rigthImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = ColorPallet.labelSecondary
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

    private func updateView() {
        guard let viewModel else { return }
        textField.placeholder = viewModel.placeHolder
        if let systemImageName = viewModel.systemImageName {
            let image = UIImage(systemName: systemImageName)
            rigthImageView.image = image
            rigthImageView.isHidden = false
        } else {
            rigthImageView.isHidden = true
        }
        setNeedsLayout()
    }

    public override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = ColorPallet.backgroundSecondary
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
    }

    private func applyLayout() {
        [rigthImageView, mainStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        addToEdges(subview: mainStackView, left: 10, right: -10)
        NSLayoutConstraint.activate([
            rigthImageView.heightAnchor.constraint(equalToConstant: 25),
            rigthImageView.widthAnchor.constraint(equalToConstant: 25)
        ])
    }
}
