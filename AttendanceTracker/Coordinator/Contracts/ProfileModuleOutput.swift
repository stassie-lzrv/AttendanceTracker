import Foundation

protocol ProfileModuleOutput {
    func showError()
    func userInfoChanged(_ newUser: User)
}
