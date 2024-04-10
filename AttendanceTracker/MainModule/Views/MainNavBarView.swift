import Foundation
import UIKit

public final class MainNavBarView: UIView {

    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.contentMode = .scaleAspectFit
        stack.spacing = 10
        return stack
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = ColorPallete.labelPrimary
        return label
    }()

    let profileIcon: UIButton = {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .default)
        let image = UIImage(systemName: "person")?.applyingSymbolConfiguration(largeConfig)
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.tintColor = ColorPallete.labelSecondary
        return button
    }()

    let qrIcon: UIButton = {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .default)
        let image = UIImage(systemName: "qrcode.viewfinder")?.applyingSymbolConfiguration(largeConfig)
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.tintColor = ColorPallete.labelSecondary
        return button
    }()

    public override init(frame: CGRect) {
        super.init(frame: .zero)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = .clear
        setupSubviews()
        applyLayout()
    }

    private func setupSubviews() {
        addSubview(mainStackView)
        [nameLabel, profileIcon, qrIcon].forEach {
            mainStackView.addArrangedSubview($0)
        }
    }

    private func applyLayout() {
        addToEdges(subview: mainStackView, left: 10, right: -5)
    }

}
