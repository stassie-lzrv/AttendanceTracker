import SnapshotTesting
import XCTest
@testable import AttendanceTracker

final class LoginViewSnapshotTests: XCTestCase {

    private var sut: LoginView!

    override func setUp() {
        super.setUp()

        sut = LoginView()
        sut.frame = CGRect(x: 0, y: 0, width: 393, height: 852)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_LoginView_login() {
        sut.configure(type: .login)
        assertSnapshot(of: sut, as: .image)
    }
    
    func test_LoginView_registartion() {
        sut.configure(type: .registration)
        assertSnapshot(of: sut, as: .image)
    }
}
