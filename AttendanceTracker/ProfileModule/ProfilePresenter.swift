import Foundation

public protocol ProfileModuleInput {
    
}

public protocol ProfileViewOutput {
    func viewDidLoad()
    func saveButtonTapped(name: String, email: String)
}

class ProfilePresenter {
    weak var view: ProfileViewInput?

    var output: ProfileModuleOutput?
    
    private let decoder = JSONDecoder()
    private let apiService: APIService
    private let token: String
    private var user: User
    
    init(apiService: APIService, token: String, user: User) {
        self.apiService = apiService
        self.token = token
        self.user = user
    }
    
    private func changeUserInfo(name: String, email: String) async -> Result<User, NetworkError> {
        guard let data = try? await apiService.postRequest(["token": token, "name": name, "email": email], endpoint: .changeUserInfo) else {
            return .failure(.failedRequest)
        }
        guard let newUser = try? decodeUserInfo(from: data) else { return .failure(.decodingError) }
        return .success(newUser)
    }
    
    
    private func decodeUserInfo(from data: Data) throws -> User {
        let response = try decoder.decode(UserInfoResponse.self, from: data)
        return User(name: response.name, email: response.email, userType: response.isStudent ? .student : .teacher)
    }
}

extension ProfilePresenter: ProfileModuleInput {
    
}

extension ProfilePresenter: ProfileViewOutput {
    func viewDidLoad() {
        view?.configure(name: user.name, email: user.email)
    }
    
    func saveButtonTapped(name: String, email: String) {
        guard name != user.name || email != user.email else { return }
        Task {
            let response = await changeUserInfo(name: name, email: email)
            switch response {
            case .success(let newUser):
                self.user = newUser
                view?.configure(name: newUser.name, email: newUser.email)
                output?.userInfoChanged(newUser)
            case .failure:
                output?.showError()
            }
        }
    }
}

