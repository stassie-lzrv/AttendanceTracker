import Foundation
import UIKit

public protocol ProfileViewInput: AnyObject {
    func configure(name: String, email: String)
}

final class ProfileViewController: UIViewController {
    var output: ProfileViewOutput?
    var customView: ProfileViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
        let customView = ProfileView()
        self.customView = customView
        customView.configure()
        customView.delegate = self
        view = customView
        
        navigationItem.hidesBackButton = true
        if let image = UIImage(systemName: "chevron.backward")?.withTintColor(.black) {
            let sizeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .default)
            let button = UIBarButtonItem(image: image.applyingSymbolConfiguration(sizeConfig), style: .plain, target: self, action: #selector(backButtonTapped))
            self.navigationItem.leftBarButtonItem = button
        }
    }
    
    @objc
    func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ProfileViewController: ProfileViewInput {
    func configure(name: String, email: String) {
        customView?.configure(name: name, email: email)
    }
    
}

extension ProfileViewController: ProfileViewControllerDelegate {
    func saveButtonTapped(name: String, email: String) {
        output?.saveButtonTapped(name: name, email: email)
    }
    

}
