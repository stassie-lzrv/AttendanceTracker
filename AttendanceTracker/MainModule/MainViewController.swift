import Foundation
import UIKit

public protocol MainViewInput: AnyObject {
}

final class MainViewController: UIViewController {
    var output: MainViewOutput?

    override func viewDidLoad() {
        super.viewDidLoad()
        let customView = MainView()
        customView.delegate = self
        customView.configure()
        view = customView
    }

}

extension MainViewController: MainViewInput {

}

extension MainViewController: MainViewControllerDelegate {

}

extension MainViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        print(dateComponents)
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }


}
