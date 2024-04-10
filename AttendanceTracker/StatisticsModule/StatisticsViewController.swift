import Foundation
import UIKit

public protocol StatisticsViewInput: AnyObject {
    func reloadTableView()
    func setTitle(title: String, subtitle: String?)
}

final class StatisticsViewController: UIViewController {
    var output: StatisticsViewOutput?
    var customView: StatisticsViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
        let customView = StatisticsView()
        self.customView = customView
        customView.delegate = self
        customView.configure()
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

extension StatisticsViewController: StatisticsViewInput {

    func setTitle(title: String, subtitle: String?) {
        customView?.configure(title: title, percentage: subtitle ?? "")
    }
    
    func reloadTableView() {
        customView?.reloadTableView()
    }
}

extension StatisticsViewController: StatisticsViewControllerDelegate {

}

extension StatisticsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        output?.displayedData.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell,
              let model = output?.displayedData[indexPath.row] else {
            return UITableViewCell()
        }
        cell.set(model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        output?.showDetailedStatistics(index: indexPath.row)
    }
}
