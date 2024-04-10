import SnapshotTesting
import XCTest
@testable import AttendanceTracker

final class NewCourseViewSnapshotTests: XCTestCase {

    private var sut: NewCourseView!

    override func setUp() {
        super.setUp()

        sut = NewCourseView()
        sut.frame = CGRect(x: 0, y: 0, width: 393, height: 852)
        sut.configure()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_NewCourseView_student() {
        sut.configure(for: .student)
        assertSnapshot(of: sut, as: .image)
    }
    
    func test_NewCourseView_teacher() {
        sut.configure(for: .teacher)
        assertSnapshot(of: sut, as: .image)
    }
}
