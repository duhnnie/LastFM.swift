import Foundation
@testable import swiftfm

final class RequesterMock: Requester {
    internal private(set) var buildCalls: [(
        params: [(String, String)],
        secure: Bool)
    ] = []

    internal private(set) var buildReturns = [URL]()

    internal private(set) var makeGetRequestCalls: [(
        url: URL,
        headers: [String: String]?,
        onCompletion: (Result<Data, ServiceError>) -> Void
    )] = []

    private let url: URL
    internal var makeRequestData: Data
    internal var makeRequestError: ServiceError?

    internal init(url: URL, makeRequestData: Data, makeRequestError: ServiceError? = nil) {
        self.url = url
        self.makeRequestError = makeRequestError
        self.makeRequestData = makeRequestData
    }

    func build(params: [(String, String)], secure: Bool) -> URL {
        buildCalls.append((
            params: params,
            secure: secure
        ))

        buildReturns.append(url)

        return url
    }

    func makeGetRequest(
        url: URL,
        headers: [String : String]?,
        onCompletion: @escaping (Result<Data, ServiceError>) -> Void
    ) {
        makeGetRequestCalls.append((
            url: url,
            headers: headers,
            onCompletion: onCompletion
        ))

        if makeRequestError != nil {
            onCompletion(.failure(makeRequestError!))
        } else {
            onCompletion(.success(makeRequestData))
        }
    }

    func clearMock() {
        buildCalls.removeAll()
        buildReturns.removeAll()
        makeGetRequestCalls.removeAll()
    }
}
