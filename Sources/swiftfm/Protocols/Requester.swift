import Foundation

internal protocol Requester {
    func build(params: [(String, String)], secure: Bool) -> URL

    func makeGetRequest(
        url: URL,
        headers: [String: String]?,
        onCompletion: @escaping (Result<Data, ServiceError>) -> Void
    )
}
