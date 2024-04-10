import SnapshotTesting
import XCTest
@testable import AttendanceTracker

final class AuthViewSnapshotTests: XCTestCase {

    private var sut: AuthView!

    override func setUp() {
        super.setUp()

        sut = AuthView()
        sut.frame = CGRect(x: 0, y: 0, width: 393, height: 852)
        sut.configure()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_AuthView() {
        assertSnapshot(of: sut, as: .image)
    }
}

