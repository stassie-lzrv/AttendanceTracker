import Foundation

struct User {
    let name: String
    let email: String
    let userType: UserType
}

public enum UserType: Decodable {
    case student
    case teacher
}
