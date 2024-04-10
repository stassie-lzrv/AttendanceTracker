import Foundation

public struct TimeTableResponse: Decodable {
    let name: String
    let time: String
    let classId: String
}
