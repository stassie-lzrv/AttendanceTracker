import Foundation
import UIKit

public protocol MainViewInput: AnyObject {
    func configure(name: String, userType: UserType)
    func reloadTimeTable()
    
    func presentQRWidget(_ qr: UIImage)
}

final class MainViewController: UIViewController {
    var output: MainViewOutput?
    var viewDelegate: MainViewDelegate?
    
    let qrWidget = QRWidgetView()

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
        let customView = MainView()
        viewDelegate = customView
        customView.delegate = self
        customView.configure()
        view = customView
        navigationItem.hidesBackButton = true
        configureQRWidget()
    }
    
    private func configureQRWidget() {
        qrWidget.isHidden = true
        qrWidget.closeButton.addTarget(self, action: #selector(hideQRWidget), for: .touchUpInside)
        
        view.addSubview(qrWidget)
        qrWidget.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            qrWidget.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            qrWidget.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            qrWidget.widthAnchor.constraint(equalToConstant: 300),
            qrWidget.heightAnchor.constraint(equalToConstant: 300)
        ])
    }

    @objc
    func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    func hideQRWidget() {
        qrWidget.isHidden = true
    }

}

extension MainViewController: MainViewInput {
    func configure(name: String, userType: UserType) {
        viewDelegate?.setName(name: name, userType: userType)
    }
    
    func reloadTimeTable() {
        viewDelegate?.reloadTableView()
    }
    
    func presentQRWidget(_ qr: UIImage) {
        qrWidget.isHidden = false
        qrWidget.setImage(qr)
    }
}

extension MainViewController: MainViewControllerDelegate {
    
    func showCourseList() {
        output?.showCourseList()
    }
    
    func navigateToProfile() {
        output?.navigateToProfile()
    }
    
    func navigateToQR() {
        output?.navigateToQR()
    }

}

extension MainViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let dateComponents else { return }
        output?.didSelectDate(dateComponents)
        viewDelegate?.reloadTableView()
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        output?.timeTable.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell,
              let model = output?.timeTable[indexPath.row] else {
            return UITableViewCell()
        }
        let viewModel = MainTableViewCell.ViewModel(title: model.name, subtitle: model.time)
        cell.set(viewModel)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedModel = output?.timeTable[indexPath.row] else { return }
        output?.didSelectCell(selectedModel)
    }

}
