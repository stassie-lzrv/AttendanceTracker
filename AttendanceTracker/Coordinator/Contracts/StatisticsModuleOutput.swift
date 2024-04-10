import Foundation

protocol StatisticsModuleOutput {
    func showError()
    func showDetailStatictics(courseId: String, classId: String, studentId: String?)
}
