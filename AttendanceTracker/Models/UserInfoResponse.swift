import Foundation

struct UserInfoResponse: Decodable {
    let name: String
    let email: String
    let isStudent: Bool
}
