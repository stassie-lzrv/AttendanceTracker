import Foundation

public protocol CourseListModuleInput { }

public protocol CourseListViewOutput {
    var courses: [CourseResponse] { get }
    
    func viewWillAppear()
    func showAddCourseScreen()
    func didSelectCourse(id: String)
}

class CourseListPresenter {
    weak var view: CourseListViewInput?

    var output: CourseListModuleOutput?
    var courses: [CourseResponse] = [] {
        didSet {
            view?.reloadTableView()
        }
    }
    
    private let token: String
    private let apiService: APIService
    private let decoder = JSONDecoder()
    
    init(token: String, apiService: APIService) {
        self.token = token
        self.apiService = apiService
    }
    
    private func getCourseList() async -> Result<[CourseResponse], NetworkError> {
        guard let data = try? await apiService.postRequest(["token": token], endpoint: .getCourseList) else {
            return .failure(.failedRequest)
        }
        guard let courses = try? decodeCourses(from: data) else { return .failure(.decodingError) }
        return .success(courses)
    }
    
    private func decodeCourses(from data: Data) throws -> [CourseResponse] {
        let decoder = JSONDecoder()
        return try decoder.decode([CourseResponse].self, from: data)
    }
}

extension CourseListPresenter: CourseListViewOutput, CourseListModuleInput {
    
    func viewWillAppear() {
        Task {
            let response = await getCourseList()
            switch response {
            case .success(let courses):
                self.courses = courses
            case .failure:
                output?.showError()
            }
        }
    }
    
    func showAddCourseScreen() {
        output?.showAddCourseScreen()
    }
    
    func didSelectCourse(id: String) {
        output?.showDetailedStatistics(for: id)
    }
}

