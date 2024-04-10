import Foundation

public protocol APIService {
    func getRequest(endpoint: Endpoint) async throws -> Data
    func postRequest(_ post: [String: Any], endpoint: Endpoint) async throws -> Data
}

struct APIServiceImpl: APIService {
    let resourceURL = "http://localhost:8080/"
    let decoder = JSONDecoder()
    
    func getRequest(endpoint: Endpoint) async throws -> Data {
        guard let url = makeURL(endpoint) else { throw NetworkError.wrongURL}
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
    
    func postRequest(_ post: [String: Any], endpoint: Endpoint) async throws -> Data {
        let urlRequest = try makePostRequest(post: post, endpoint: endpoint)
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        return data
    }
    
    private func makePostRequest(post: [String: Any], endpoint: Endpoint) throws -> URLRequest {
        guard let url = makeURL(endpoint) else { throw NetworkError.wrongURL}
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let httpBody = try JSONSerialization.data(withJSONObject: post)
        urlRequest.httpBody = httpBody
        return urlRequest
    }
    
    private func makeURL(_ endpoint: Endpoint) -> URL? {
        guard let url = URL(string: "http://localhost:8080/\(endpoint.rawValue)") else { return nil }
        return url
    }
    
    
}
