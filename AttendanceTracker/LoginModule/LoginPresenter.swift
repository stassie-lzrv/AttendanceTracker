import Foundation

public protocol LoginModuleInput { }

public protocol LoginViewOutput {
    func continueWithRegistration(_ name: String, _ email: String, _ password: String)
    func continueWithLogin(_ email: String, _ password: String)

    var loginType: LoginView.LoginType { get }
}

class LoginPresenter {

    weak var view: LoginViewInput?

    var output: LoginModuleOutput?
    
    internal let loginType: LoginView.LoginType
    private let apiService: APIService
    private let decoder = JSONDecoder()

    init(loginType: LoginView.LoginType, apiService: APIService) {
        self.loginType = loginType
        self.apiService = apiService
    }
    
    private func login(
        _ email: String,
        _ password: String
    ) async -> Result<AuthResponce, NetworkError> {
        guard let data = try? await apiService.postRequest(["email": email, "password": password], endpoint: .login) else {
            return .failure(.failedRequest)
        }
        guard let response = try? decodeUser(from: data) else { return .failure(.decodingError) }
        return .success(response)
    }
    
    private func registration(
        _ name: String,
        _ email: String,
        _ password: String
    ) async -> Result<AuthResponce, NetworkError> {
        guard let data = try? await apiService.postRequest(["name": name, "email": email, "password": password], endpoint: .registration) else {
            return .failure(.failedRequest)
        }
        guard let response = try? decodeUser(from: data) else { return .failure(.decodingError) }
        return .success(response)
    }
    
    private func decodeUser(from data: Data) throws -> AuthResponce {
        return try decoder.decode(AuthResponce.self, from: data)
    }
}

extension LoginPresenter: LoginViewOutput, LoginModuleInput {
    func continueWithRegistration(_ name: String, _ email: String, _ password: String) {
        Task {
            let result = await registration(name, email, password)
            switch result {
            case .success(let token):
                output?.continueWithRegistration(token)
            case .failure(_):
                output?.showError()
            }
        }
    }

    func continueWithLogin(_ email: String, _ password: String) {
        Task {
            let result = await login(email, password)
            switch result {
            case .success(let token):
                output?.continueWithLogin(token)
            case .failure(_):
                output?.showError()
            }
        }
    }

}

