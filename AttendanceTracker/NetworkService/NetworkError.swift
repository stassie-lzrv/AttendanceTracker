import Foundation

enum NetworkError: Error {
    case failedRequest
    case decodingError
    case wrongURL
}
