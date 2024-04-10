import Foundation

public enum Endpoint: String {
    case login = "login"
    case registration = "registration"

    case getUserInfo = "get_user_info"
    case getTimeTable = "get_timetable"
    case getQRImage = "get_qr_image"
    
    case changeUserInfo = "change_user_info"
    
    case getCourseList = "get_course_list"
    
    case getStatisticsForStudent = "get_statistics_for_student"
    case getStatisticsForTeacher = "get_statistics_for_teacher"
    case getClassStatisticsForTeacher = "get_class_statistics_for_teacher"
    case getStudentStatisticsForTeacher = "get_student_statistics_for_teacher"
    
    case didScanQR = "scan_qr"
    case didEnterAttendanceCode = "enter_attendance_code"
}
