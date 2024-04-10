import Foundation
import UIKit

class NewCourseWidget: UIView {
    private let courseText = MainTextField()
    let title: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 0
        label.textColor = ColorPallete.labelPrimary
        return label
    }()
    let shareButton = UIButton(type: .system)
    let closeButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    public func setText(_ text: String) {
        courseText.set(MainTextField.ViewModel(text: text, leftSystemImageName: "square.on.square"))
    }

    private func setupView() {
        backgroundColor = ColorPallete.backgroundPrimary
        layer.borderColor = ColorPallete.accentColor.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 20

        addSubview(courseText)
        addSubview(title)
        let image = UIImage(systemName: "xmark")?.withTintColor(ColorPallete.labelPrimary)
        closeButton.setImage(image, for: .normal)
        addSubview(closeButton)

        shareButton.setTitle("Поделиться", for: .normal)
        addSubview(shareButton)

        setupConstraints()
    }
    
    private func setupConstraints() {
        title.translatesAutoresizingMaskIntoConstraints = false
        courseText.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            courseText.centerXAnchor.constraint(equalTo: centerXAnchor),
            courseText.centerYAnchor.constraint(equalTo: centerYAnchor),
            courseText.widthAnchor.constraint(equalToConstant: 250),
            courseText.heightAnchor.constraint(equalToConstant: 50),
            
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 16),
            closeButton.heightAnchor.constraint(equalToConstant: 16),
            
            title.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            title.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            shareButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            shareButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
