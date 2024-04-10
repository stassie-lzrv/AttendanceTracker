import Foundation
import UIKit

class QRWidgetView: UIView {

    var imageView = UIImageView()
    var shareButton = UIButton(type: .system)
    var closeButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    public func setImage(_ image: UIImage) {
        imageView.image = image
    }

    private func setupView() {
        backgroundColor = ColorPallete.backgroundPrimary
        layer.borderColor = ColorPallete.accentColor.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 20

        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)

        let image = UIImage(systemName: "xmark")?.withTintColor(ColorPallete.labelPrimary)
        closeButton.setImage(image, for: .normal)
        addSubview(closeButton)

        shareButton.setTitle("Поделиться", for: .normal)
        addSubview(shareButton)

        setupConstraints()
    }
    
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 250),
            imageView.heightAnchor.constraint(equalToConstant: 250),
            
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 16),
            closeButton.heightAnchor.constraint(equalToConstant: 16),
            
            shareButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            shareButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
