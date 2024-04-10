import SnapshotTesting
import XCTest
@testable import AttendanceTracker

final class StatisticsViewSnapshotTests: XCTestCase {

    private var sut: StatisticsView!
    private var delegateMock: StatisticsViewControllerDelegateMock!

    override func setUp() {
        super.setUp()

        delegateMock = StatisticsViewControllerDelegateMock()
        sut = StatisticsView()
        sut.delegate = delegateMock
        sut.frame = CGRect(x: 0, y: 0, width: 393, height: 852)
        sut.configure()
        sut.configure(title: "Заголовок", percentage: "100%")
    }

    override func tearDown() {
        sut = nil
        delegateMock = nil
        super.tearDown()
    }

    func test_StatisticsView_student() {
        delegateMock.mock = delegateMock.mockStudent
        assertSnapshot(of: sut, as: .image)
    }
    
    func test_StatisticsView_teacher() {
        delegateMock.mock = delegateMock.mockTeacher
        assertSnapshot(of: sut, as: .image)
    }
    
    func test_StatisticsView_teacher_detail_class() {
        delegateMock.mock = delegateMock.mockTeacherClass
        assertSnapshot(of: sut, as: .image)
    }
    
    func test_StatisticsView_teacher_detail_student() {
        delegateMock.mock = delegateMock.mockTeacherDetail
        assertSnapshot(of: sut, as: .image)
    }
}

class StatisticsViewControllerDelegateMock: NSObject, StatisticsViewControllerDelegate {
    var mock: [MainTableViewCell.ViewModel] = []
    
    let mockStudent  = [
        MainTableViewCell.ViewModel(title: "17.01.2024", leftSystemImageName: "checkmark.circle", leftImageColor: ColorPallete.greenColor),
        MainTableViewCell.ViewModel(title: "20.01.2024", leftSystemImageName: "checkmark.circle", leftImageColor: ColorPallete.greenColor),
        MainTableViewCell.ViewModel(title: "24.01.2024", leftSystemImageName: "xmark.circle", leftImageColor: ColorPallete.redColor),
        MainTableViewCell.ViewModel(title: "27.01.2024", leftSystemImageName: "checkmark.circle", leftImageColor: ColorPallete.greenColor)
    ]
    
    let mockTeacher = [
        MainTableViewCell.ViewModel(title: "23.02.2024", subtitle: "89%"),
        MainTableViewCell.ViewModel(title: "01.03.2024", subtitle: "81%"),
        MainTableViewCell.ViewModel(title: "08.03.2024", subtitle: "93%")
    ]
    
    let mockTeacherClass = [
        MainTableViewCell.ViewModel(title: "Платонова А. Т.", subtitle: "atplatonova@edu.hse.ru", leftSystemImageName: "xmark.circle", leftImageColor: ColorPallete.redColor),
        MainTableViewCell.ViewModel(title: "Крылова Д. Р.", subtitle: "drkrylova@edu.hse.ru", leftSystemImageName: "checkmark.circle", leftImageColor: ColorPallete.greenColor),
        MainTableViewCell.ViewModel(title: "Никитина А. Я.", subtitle: "aynikitina@edu.hse.ru", leftSystemImageName: "xmark.circle", leftImageColor: ColorPallete.redColor)
    ]
        
    let mockTeacherDetail  = [
        MainTableViewCell.ViewModel(title: "26.01.2024", leftSystemImageName: "checkmark.circle", leftImageColor: ColorPallete.greenColor),
        MainTableViewCell.ViewModel(title: "02.02.2024", leftSystemImageName: "xmark.circle", leftImageColor: ColorPallete.redColor),
        MainTableViewCell.ViewModel(title: "09.02.2024", leftSystemImageName: "checkmark.circle", leftImageColor: ColorPallete.greenColor)
    ]
        
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
