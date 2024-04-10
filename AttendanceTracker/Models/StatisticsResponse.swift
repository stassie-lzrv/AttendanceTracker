import Foundation

public struct StudentStatisticsResponse: Decodable {
    let courseId: String
    let totalAttendance: String
    let name: String
    let classes: [StudentStatisticsClassResponse]
}

public struct StudentStatisticsClassResponse: Decodable {
    let date: String
    let didAttend: Bool
}


public struct TeacherStatisticsResponse: Decodable {
    let courseId: String
    let name: String
    let totalAttendance: String
    let classes: [TeacherStatisticsClassResponse]
}

public struct TeacherStatisticsClassResponse: Decodable {
    let classId: String
    let date: String
    let attendance: String
}


public struct TeacherClassDetailStatisticsResponse: Decodable {
    let classId: String
    let className: String
    let totalAttendance: String
    let classes: [TeacherClassDetailStatisticsClassResponse]
}

public struct TeacherClassDetailStatisticsClassResponse: Decodable {
    let didAttend: Bool
    let studentId: String
    let studentName: String
    let studentEmail: String
}


public struct TeacherStudentDetailStatisticsResponse: Decodable {
    let studentName: String
    let totalAttendance: String
    let classes: [StudentStatisticsClassResponse]
}

