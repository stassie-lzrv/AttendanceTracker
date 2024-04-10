import Foundation

public protocol QRModuleInput {
    
}

public protocol QRViewOutput: AnyObject {
    func processQRValue(_ value: String)
    func didEnterCode(inputCode: String)
}

class QRPresenter {
    weak var view: QRViewInput?

    var output: QRModuleOutput?
    
    private let token: String
    private let apiService: APIService
    private let decoder = JSONDecoder()
    
    private var classId: String?

    init(token: String, apiService: APIService) {
        self.token = token
        self.apiService = apiService
    }

    private func didScanQR(classId: String) async -> Result<QRScanResponse, NetworkError> {
        guard let data = try? await apiService.postRequest(["token": token, "classId": classId], endpoint: .didScanQR) else {
            return .failure(.failedRequest)
        }
        guard let timeTable = try? decodeQRResponse(from: data) else { return .failure(.decodingError) }
        return .success(timeTable)
    }
    
    private func decodeQRResponse(from data: Data) throws -> QRScanResponse {
        return try decoder.decode(QRScanResponse.self, from: data)
    }
    
    private func confirmAttendance(classId: String, value: String) async -> Result<QRConfirmationResponse, NetworkError> {
        guard let data = try? await apiService.postRequest(["token": token, "classId": classId, "value": value], endpoint: .didEnterAttendanceCode) else {
            return .failure(.failedRequest)
        }
        guard let timeTable = try? decodeQRConfirmationResponse(from: data) else { return .failure(.decodingError) }
        return .success(timeTable)
    }
    
    private func decodeQRConfirmationResponse(from data: Data) throws -> QRConfirmationResponse {
        return try decoder.decode(QRConfirmationResponse.self, from: data)
    }
}

extension QRPresenter: QRModuleInput {
    
}

extension QRPresenter: QRViewOutput {
    func didEnterCode(inputCode: String) {
        Task {
            guard let classId else { return }
            let response = await confirmAttendance(classId: classId, value: inputCode)
            switch response {
                case .success(let code):
                    if code.isSuccessful {
                        view?.showSuccessAlert()
                    } else {
                        view?.showFailedAlert()
                    }
                case .failure:
                    output?.showError()
            }
        }
    }
    
    func processQRValue(_ value: String) {
        Task {
            let response = await didScanQR(classId: value)
            switch response {
            case .success(let code):
                view?.showConfirmationSheet(code: code.code)
            case .failure:
                output?.showError()
            }
        }
    }
}

