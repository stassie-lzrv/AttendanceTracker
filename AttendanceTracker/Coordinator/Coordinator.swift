import Foundation
import UIKit

protocol Coordinator {
    func build() async -> UINavigationController?
}
