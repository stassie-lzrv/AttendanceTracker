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

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.text = "Лазарева Анастасия"
        label.textColor = ColorPallet.labelPrimary
        return label
    }()

    private let profileIcon: UIButton = {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .default)
        let image = UIImage(systemName: "person")?.applyingSymbolConfiguration(largeConfig)
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.tintColor = ColorPallet.labelSecondary
        return button
    }()

    private let courseListIcon:UIButton = {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .default)
        let image = UIImage(systemName: "books.vertical")?.applyingSymbolConfiguration(largeConfig)
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.tintColor = ColorPallet.labelSecondary
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
        [nameLabel, profileIcon, courseListIcon].forEach {
            mainStackView.addArrangedSubview($0)
        }
    }

    private func applyLayout() {
        addToEdges(subview: mainStackView, left: 10, right: -5)
    }

}
