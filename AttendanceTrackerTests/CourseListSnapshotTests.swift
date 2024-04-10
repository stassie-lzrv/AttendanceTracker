import SnapshotTesting
import XCTest
@testable import AttendanceTracker

final class CourseListViewSnapshotTests: XCTestCase {

    private var sut: CourseListView!
    private var delegateMock: CourseListViewControllerDelegateMock!

    override func setUp() {
        super.setUp()

        delegateMock = CourseListViewControllerDelegateMock()
        sut = CourseListView()
        sut.delegate = delegateMock
        sut.frame = CGRect(x: 0, y: 0, width: 393, height: 852)
        sut.configure()
    }

    override func tearDown() {
        sut = nil
        delegateMock = nil
        super.tearDown()
    }

    func test_CourseListView() {
        assertSnapshot(of: sut, as: .image)
    }
}

class CourseListViewControllerDelegateMock: NSObject, CourseListViewControllerDelegate {
    var mock: [MainTableViewCell.ViewModel] = [
        MainTableViewCell.ViewModel(title: "Машинное обучение", subtitle: "Преподаватель: Петров А.В."),
        MainTableViewCell.ViewModel(title: "Математический анализ", subtitle: "Преподаватель: Петров И.И."),
        MainTableViewCell.ViewModel(title: "Разработка и анализ требования", subtitle: "Преподаватель: Сидоров И.И."),
        MainTableViewCell.ViewModel(title: "Проектирование архитектуры", subtitle: "Преподаватель: Васильева М.И."),
        MainTableViewCell.ViewModel(title: "Дизайн", subtitle: "Преподаватель: Кузнецова Р.П.")
    ]
    func showAddCourseScreen() {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mock.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else {
            return UITableViewCell()
        }
        
        cell.set(mock[indexPath.row])
        return cell
    }
    
    public override init() {}
    
}
