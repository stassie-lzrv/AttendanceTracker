import Foundation
import UIKit

public protocol CourseListViewInput: AnyObject {
    func reloadTableView()
}

final class CourseListViewController: UIViewController {
    var output: CourseListViewOutput?
    var customView: CourseListViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let customView = CourseListView()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output?.viewWillAppear()
    }

    @objc
    func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension CourseListViewController: CourseListViewInput {
    func reloadTableView() {
        customView?.reloadTableView()
    }
}

extension CourseListViewController: CourseListViewControllerDelegate {
    func showAddCourseScreen() {
        output?.showAddCourseScreen()
    }
}

extension CourseListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        output?.courses.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell,
              let model = output?.courses[indexPath.row]
        else {
            return UITableViewCell()
        }
        let viewModel = MainTableViewCell.ViewModel(title: model.name, subtitle: model.teacherName)
        cell.set(viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let courseId = output?.courses[indexPath.row].courseId else { return }
        output?.didSelectCourse(id: courseId)
    }
}

