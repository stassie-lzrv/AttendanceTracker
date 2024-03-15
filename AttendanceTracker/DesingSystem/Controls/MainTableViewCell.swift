import Foundation
import UIKit

class MainTableViewCell: UITableViewCell {

    public struct ViewModel {
        let title: String
        let subtitle: String?
        let systemImageName: String?
        let action: (() -> Void)?

        init(
            title: String,
            titleColor: UIColor = ColorPallet.labelSecondary,
            subtitle: String? = nil,
            systemImageName: String? = nil,
            action: (() -> Void)? = nil
        ) {
            self.title = title
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
        imageView.tintColor = ColorPallet.labelSecondary
        return imageView
    }()

    private let title: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.text = "Название"
        label.textColor = ColorPallet.labelSecondary
        label.textAlignment = .left
        return label
    }()

    private let subtitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .regular)
        label.text = "Dhtvz"
        label.textColor = ColorPallet.labelSecondary
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
        stack.spacing = 10
        return stack
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        backgroundColor = .blue
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func set(_ viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    private func updateView() {
        guard let viewModel else { return }
        title.text = viewModel.title
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

    private func setupView() {
        backgroundColor = ColorPallet.backgroundSecondary
        setupSubviews()
        applyLayout()
    }

    private func setupSubviews() {
        mainStack.addArrangedSubview(rigthImageView)
        mainStack.addArrangedSubview(verticalStack)
        verticalStack.addArrangedSubview(title)
        verticalStack.addArrangedSubview(subtitle)
    }

    private func applyLayout() {
        addToEdges(subview: mainStack, top: 12, left: 10, right: -10, bottom: -12)

        NSLayoutConstraint.activate([
            rigthImageView.heightAnchor.constraint(equalToConstant: 25),
            rigthImageView.widthAnchor.constraint(equalToConstant: 25)
        ])
    }
}
