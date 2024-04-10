import Foundation
import UIKit

extension UIImage {
    static func getImageFrom(base64String: String) -> UIImage? {
        if let imageData = Data(base64Encoded: base64String) {
            return UIImage(data: imageData)
        }
        return nil
    }
}
