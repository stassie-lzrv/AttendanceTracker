import Foundation

public struct CourseResponse: Decodable {
    let courseId: String
    let name: String
    let teacherName: String
}
