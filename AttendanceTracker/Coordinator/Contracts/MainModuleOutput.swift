import Foundation

protocol MainModuleOutput {
    func showCourseList()
    func navigateToProfile(_ user: User)
    func navigateToQR()
    func showError()
}
