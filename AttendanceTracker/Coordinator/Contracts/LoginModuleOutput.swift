import Foundation

protocol LoginModuleOutput {
    func continueWithRegistration(_ token: AuthResponce)
    func continueWithLogin(_ token: AuthResponce)
    func showError()
}
