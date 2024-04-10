import Foundation

public protocol StatisticsModuleInput {
    
}

public protocol StatisticsViewOutput {
    var displayedData: [MainTableViewCell.ViewModel] { get }
    func viewDidLoad()
    func showDetailedStatistics(index: Int)
}

class StatisticsPresenter {
    enum TeacherStatisticsType {
        case common
        case detailedByDate
        case detailedByUser
    }
    weak var view: StatisticsViewInput?

    var output: StatisticsModuleOutput?

    private let token: String
    private let apiService: APIService
    private let decoder = JSONDecoder()
    private let courseId: String
    private let userType: UserType
    
    private let classId: String?
    private let studentId: String?
    
    private var currentStudentStatistics: StudentStatisticsResponse?
    private var currentTeacherStatistics: TeacherStatisticsResponse?
    private var currentTeacherClassStatistics: TeacherClassDetailStatisticsResponse?
    private var currentTeacherStudentStatistics: TeacherStudentDetailStatisticsResponse?
    
    var displayedData: [MainTableViewCell.ViewModel] = []
    
    init(token: String, apiService: APIService, courseId: String, userType: UserType, classId: String?, studentId: String?) {
        self.token = token
        self.apiService = apiService
        self.courseId = courseId
        self.userType = userType
        self.classId = classId
        self.studentId = studentId
    }
    
    private func getStatisticsForStudent() async -> Result<StudentStatisticsResponse, NetworkError> {
        guard let data = try? await apiService.postRequest(["token": token, "couseId": courseId], endpoint: .getStatisticsForStudent) else {
            return .failure(.failedRequest)
        }
        guard let statistics = try? decodeStatisticsForStudent(from: data) else { return .failure(.decodingError) }
        return .success(statistics)
    }
    
    private func decodeStatisticsForStudent(from data: Data) throws -> StudentStatisticsResponse {
        return try decoder.decode(StudentStatisticsResponse.self, from: data)
    }
    
    private func getStatisticsForTeacher() async -> Result<TeacherStatisticsResponse, NetworkError> {
        guard let data = try? await apiService.postRequest(["token": token, "couseId": courseId], endpoint: .getStatisticsForTeacher) else {
            return .failure(.failedRequest)
        }
        guard let statistics = try? decodeStatisticsForTeacher(from: data) else { return .failure(.decodingError) }
        return .success(statistics)
    }
    
    private func decodeStatisticsForTeacher(from data: Data) throws -> TeacherStatisticsResponse {
        return try decoder.decode(TeacherStatisticsResponse.self, from: data)
    }
    
    private func getClassStatisticsForTeacher(classId: String) async -> Result<TeacherClassDetailStatisticsResponse, NetworkError> {
        guard let data = try? await apiService.postRequest(["token": token, "couseId": courseId, "classId": classId], endpoint: .getClassStatisticsForTeacher) else {
            return .failure(.failedRequest)
        }
        guard let statistics = try? decodeClasStatisticsForTeacher(from: data) else { return .failure(.decodingError) }
        return .success(statistics)
    }
    
    private func decodeClasStatisticsForTeacher(from data: Data) throws -> TeacherClassDetailStatisticsResponse {
        return try decoder.decode(TeacherClassDetailStatisticsResponse.self, from: data)
    }
    
    private func getStudentStatisticsForTeacher(classId: String, studentId: String) async -> Result<TeacherStudentDetailStatisticsResponse, NetworkError> {
        guard let data = try? await apiService.postRequest(["token": token, "couseId": courseId, "classId": classId, "studentId": studentId], endpoint: .getStudentStatisticsForTeacher) else {
            return .failure(.failedRequest)
        }
        guard let statistics = try? decodeStudentStatisticsForTeacher(from: data) else { return .failure(.decodingError) }
        return .success(statistics)
    }
    
    private func decodeStudentStatisticsForTeacher(from data: Data) throws -> TeacherStudentDetailStatisticsResponse {
        return try decoder.decode(TeacherStudentDetailStatisticsResponse.self, from: data)
    }
    
}

extension StatisticsPresenter: StatisticsModuleInput {
    
}

extension StatisticsPresenter: StatisticsViewOutput {
    func viewDidLoad() {
        Task {
            switch userType {
            case .student:
                let response = await getStatisticsForStudent()
                switch response {
                case .success(let attendance):
                    self.currentStudentStatistics = attendance
                    self.displayedData = attendance.classes.map({ MainTableViewCell.ViewModel(
                        title: $0.date,
                        leftSystemImageName: $0.didAttend ? "checkmark.circle" : "xmark.circle",
                        leftImageColor: $0.didAttend ? ColorPallete.greenColor : ColorPallete.redColor
                    )})
                    view?.setTitle(title: attendance.name, subtitle: attendance.totalAttendance)
                case .failure:
                    output?.showError()
                }
            case .teacher:
                switch getTeacherStatistics() {
                case .common:
                    await getTeacherCommonStatistics()
                case .detailedByDate:
                    await getTeacherStatisticsByDate()
                case .detailedByUser:
                    await getTeacherStatisticsForStudent()
                }
            }
            view?.reloadTableView()
        }
    }
    
    private func getTeacherStatistics() -> TeacherStatisticsType {
        if classId == nil && studentId == nil {
            return .common
        } else if studentId != nil {
            return .detailedByUser
        } else if classId != nil {
            return .detailedByDate
        }
        return .common
    }
    
    private func getTeacherCommonStatistics() async {
        let response = await getStatisticsForTeacher()
        switch response {
        case .success(let attendance):
            self.currentTeacherStatistics = attendance
            self.displayedData = attendance.classes.map({ MainTableViewCell.ViewModel(
                title: $0.date,
                subtitle: $0.attendance
            )})
            view?.setTitle(title: attendance.name, subtitle: attendance.totalAttendance)
        case .failure:
            output?.showError()
        }
    }
    
    private func getTeacherStatisticsByDate() async {
        guard let classId else { return }
        let response = await getClassStatisticsForTeacher(classId: classId)
        switch response {
        case .success(let attendance):
            self.currentTeacherClassStatistics = attendance
            self.displayedData = attendance.classes.map({ MainTableViewCell.ViewModel(
                title: $0.studentName,
                subtitle: $0.studentEmail,
                leftSystemImageName: $0.didAttend ? "checkmark.circle" : "xmark.circle",
                leftImageColor: $0.didAttend ? ColorPallete.greenColor : ColorPallete.redColor
            )})
            view?.setTitle(title: attendance.className, subtitle: attendance.totalAttendance)
        case .failure:
            output?.showError()
        }
    }
    
    private func getTeacherStatisticsForStudent() async {
        guard let classId, let studentId else { return }
        let response = await getStudentStatisticsForTeacher(classId: classId, studentId: studentId)
        switch response {
        case .success(let attendance):
            self.currentTeacherStudentStatistics = attendance
            self.displayedData = attendance.classes.map({ MainTableViewCell.ViewModel(
                title: $0.date,
                leftSystemImageName: $0.didAttend ? "checkmark.circle" : "xmark.circle",
                leftImageColor: $0.didAttend ? ColorPallete.greenColor : ColorPallete.redColor
            )})
            view?.setTitle(title: attendance.studentName, subtitle: attendance.totalAttendance)
        case .failure:
            output?.showError()
        }
    }
    
    func showDetailedStatistics(index: Int) {
        switch userType {
        case .student:
            return
        case .teacher:
            if classId != nil && studentId != nil {
                return
            } else if studentId == nil {
                guard let studentId = currentTeacherClassStatistics?.classes[index].studentId, let classId else { return }
                output?.showDetailStatictics(courseId: courseId, classId: classId, studentId: studentId)
            } else if classId == nil {
                guard let classId = currentTeacherStatistics?.classes[index].classId else { return }
                output?.showDetailStatictics(courseId: courseId, classId: classId, studentId: nil)
            }
        }
    }
}

