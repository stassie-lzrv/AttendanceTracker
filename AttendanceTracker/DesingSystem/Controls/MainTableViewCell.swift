import Foundation
import UIKit

public class MainTableViewCell: UITableViewCell {

    public struct ViewModel {
        let title: String
        let subtitle: String?
        let titleColor: UIColor
        
        let leftSystemImageName: String?
        let leftImageColor: UIColor?
        let rightSystemImageName: String?
        
        let action: (() -> Void)?

        init(
            title: String,
            titleColor: UIColor = ColorPallete.labelPrimary,
            subtitle: String? = nil,
            leftSystemImageName: String? = nil,
            leftImageColor: UIColor? = nil,
            action: (() -> Void)? = nil,
            rightSystemImageName: String? = nil
        ) {
            self.title = title
            self.titleColor = titleColor
            self.subtitle = subtitle
            self.leftSystemImageName = leftSystemImageName
            self.leftImageColor = leftImageColor
            self.action = action
            self.rightSystemImageName = rightSystemImageName
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
        imageView.tintColor = ColorPallete.labelPrimary
        return imageView
    }()
    
    private var leftImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = ColorPallete.labelPrimary
        return imageView
    }()

    private let title: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = ColorPallete.labelPrimary
        label.textAlignment = .left
        return label
    }()

    private let subtitle: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption2)
        label.textColor = ColorPallete.labelPrimary
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
        selectionStyle = .none
        setupView()
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
        if let subtitleText = viewModel.subtitle {
            subtitle.text = subtitleText
            subtitle.isHidden = false
        } else {
            subtitle.text = nil
            subtitle.isHidden = true
        }
        title.textColor = viewModel.titleColor
        title.textAlignment = .left
        subtitle.textColor = viewModel.titleColor
        if let systemImageName = viewModel.leftSystemImageName {
            var image = UIImage(systemName: systemImageName)
            leftImageView.image = image
            leftImageView.isHidden = false
        } else {
            leftImageView.isHidden = true
        }
        
        if let leftImageColor = viewModel.leftImageColor {
            leftImageView.tintColor = leftImageColor
        }
        
        if let rightSystemImageName = viewModel.rightSystemImageName {
            let image = UIImage(systemName: rightSystemImageName)
            rigthImageView.image = image
            rigthImageView.isHidden = false
        } else {
            rigthImageView.isHidden = true
        }
        setNeedsLayout()
    }

    private func setupView() {
        backgroundColor = .clear
        setupSubviews()
        applyLayout()
    }

    private func setupSubviews() {
        mainStack.addArrangedSubview(leftImageView)
        mainStack.addArrangedSubview(verticalStack)
        mainStack.addArrangedSubview(rigthImageView)
        
        verticalStack.addArrangedSubview(title)
        verticalStack.addArrangedSubview(subtitle)
    }

    private func applyLayout() {
        addToEdges(subview: mainStack, top: 12, left: 10, right: -10, bottom: -12)

        NSLayoutConstraint.activate([
            rigthImageView.heightAnchor.constraint(equalToConstant: 25),
            rigthImageView.widthAnchor.constraint(equalToConstant: 25),
            
            leftImageView.heightAnchor.constraint(equalToConstant: 25),
            leftImageView.widthAnchor.constraint(equalToConstant: 25)
        ])
    }
}
