import Foundation

protocol CourseListModuleOutput {
    func showAddCourseScreen()
    func showDetailedStatistics(for courseId: String)
    func showError()
}
