import UIKit
import Foundation

public final class QRView: UIView {
    
    private let qrFrame: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "qr_frame")
        imageView.image = image
        return imageView
    }()
    
    func configure(){
        backgroundColor = .green
        NSLayoutConstraint.activate([
            qrFrame.centerXAnchor.constraint(equalTo: centerXAnchor),
            qrFrame.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
}
