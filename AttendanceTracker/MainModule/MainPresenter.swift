import Foundation
import UIKit

public protocol MainModuleInput {

}

public protocol MainViewOutput {
    var timeTable: [TimeTableResponse] { get }
    func viewDidLoad()
    func showCourseList()
    func navigateToProfile()
    func navigateToQR()
    
    func didSelectDate(_ date: DateComponents)
    func didSelectCell(_ model: TimeTableResponse)
}

class MainPresenter {
    weak var view: MainViewInput?
    var output: MainModuleOutput?
    
    private let token: String
    private let apiService: APIService
    private let decoder = JSONDecoder()
    
    private var user: User?
    var timeTable: [TimeTableResponse] = [] {
        didSet {
            view?.reloadTimeTable()
        }
    }
    
    init(token: String, apiService: APIService) {
        self.token = token
        self.apiService = apiService
    }

    private func getTimeTable(date: DateComponents) async -> Result<[TimeTableResponse], NetworkError> {
        guard let data = try? await apiService.postRequest(["token": token, "date": date.description], endpoint: .getTimeTable) else {
            return .failure(.failedRequest)
        }
        guard let timeTable = try? decodeTimetable(from: data) else { return .failure(.decodingError) }
        return .success(timeTable)
    }
    
    private func decodeTimetable(from data: Data) throws -> [TimeTableResponse] {
        return try decoder.decode([TimeTableResponse].self, from: data)
    }
    
    private func getUserInfo() async -> Result<User, NetworkError> {
        guard let data = try? await apiService.postRequest(["token": token], endpoint: .getUserInfo) else {
            return .failure(.failedRequest)
        }
        guard let timeTable = try? decodeUserInfo(from: data) else { return .failure(.decodingError) }
        return .success(timeTable)
    }
    
    private func decodeUserInfo(from data: Data) throws -> User {
        let response = try decoder.decode(UserInfoResponse.self, from: data)
        return User(name: response.name, email: response.email, userType: response.isStudent ? .student : .teacher)
    }
    
    private func getQRImage(timeTable: TimeTableResponse) async -> Result<UIImage, NetworkError> {
        guard let data = try? await apiService.postRequest(["token": token, "classID": timeTable.classId], endpoint: .getQRImage) else {
            return .failure(.failedRequest)
        }
        guard let image = try? decodeImage(from: data) else { return .failure(.decodingError) }
        return .success(image)
    }
    
    private func decodeImage(from data: Data) throws -> UIImage? {
        let response = try decoder.decode(QRImageResponse.self, from: data)
        return UIImage.getImageFrom(base64String: response.value)
    }
}

extension MainPresenter: MainModuleInput {

}

extension MainPresenter: MainViewOutput {
    func viewDidLoad() {
        Task {
            let userInfoResponce = await getUserInfo()
            switch userInfoResponce {
                case .success(let user):
                    self.user = user
                    view?.configure(name: user.name, userType: user.userType)
                case .failure:
                    output?.showError()
            }
            let date = Date()
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)

            let timeTableResponse = await getTimeTable(date: components)
            switch timeTableResponse {
                case .success(let timeTable):
                    self.timeTable = timeTable
                case .failure:
                    output?.showError()
            }
        }
    }
    func showCourseList() {
        output?.showCourseList()
    }
    
    func navigateToProfile() {
        guard let user else { return }
        output?.navigateToProfile(user)
    }
    
    func navigateToQR() {
        output?.navigateToQR()
    }
    
    func didSelectDate(_ date: DateComponents) {
        Task {
            let timeTableResponse = await getTimeTable(date: date)
            switch timeTableResponse {
                case .success(let timeTable):
                    self.timeTable = timeTable
                case .failure:
                    output?.showError()
            }
        }
    }
    
    func didSelectCell(_ cell: TimeTableResponse) {
        Task {
            let response = await getQRImage(timeTable: cell)
            switch response {
                case .success(let image):
                    view?.presentQRWidget(image)
                case .failure:
                    output?.showError()
            }
        }
    }
}


