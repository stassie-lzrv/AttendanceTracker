import SnapshotTesting
import XCTest
@testable import AttendanceTracker

final class MainViewSnapshotTests: XCTestCase {

    private var sut: MainView!
    private var delegateMock: MainViewControllerDelegateMock!

    override func setUp() {
        super.setUp()

        delegateMock = MainViewControllerDelegateMock()
        sut = MainView()
        sut.delegate = delegateMock
        sut.frame = CGRect(x: 0, y: 0, width: 393, height: 852)
        sut.configure()
    }

    override func tearDown() {
        sut = nil
        delegateMock = nil
        super.tearDown()
    }

    func test_MainView_student() {
        sut.setName(name: "Имя Фамилия", userType: .student)
        assertSnapshot(of: sut, as: .image)
    }
    
    func test_MainView_teacher() {
        sut.setName(name: "Имя Фамилия", userType: .teacher)
        assertSnapshot(of: sut, as: .image)
    }
}

class MainViewControllerDelegateMock: NSObject, MainViewControllerDelegate {
    public override init() {}
    let mock = [
        MainTableViewCell.ViewModel(title: "Дизайн", subtitle: "12:00-13:20", leftSystemImageName: "pencil.and.outline", rightSystemImageName: "qrcode.viewfinder"),
        MainTableViewCell.ViewModel(title: "Статистика", subtitle: "13:40-15:00", leftSystemImageName: "doc.on.doc"),
        MainTableViewCell.ViewModel(title: "Разработка и анализ требования", subtitle: "16:00-17:20", leftSystemImageName: "laptopcomputer.trianglebadge.exclamationmark"),
    ]
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) { }
    
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

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func showCourseList() {}
    func navigateToProfile() {}
    func navigateToQR() {}
}
