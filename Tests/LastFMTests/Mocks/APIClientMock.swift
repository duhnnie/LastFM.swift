import Foundation
import SwiftRestClient
@testable import LastFM

final internal class APICLientMock: APIClient, Mock {
    internal var data: Data?
    internal var response: URLResponse?
    internal var error: Error?

    private(set) var getCalls = [(
        url: URL,
        headers: SwiftRestClient.Headers?,
        onCompletion: SwiftRestClient.RequestCompletion
    )]()

    private(set) var postCalls = [(
        url: URL,
        body: Data?,
        headers: SwiftRestClient.Headers?,
        onCompletion: SwiftRestClient.RequestCompletion
    )]()

    func get(
        _ url: URL,
        headers: SwiftRestClient.Headers?,
        onCompletion: @escaping SwiftRestClient.RequestCompletion
    ) {
        getCalls.append((
            url: url,
            headers: headers,
            onCompletion: onCompletion
        ))

        onCompletion(data, response, error)
    }

    func post(
        _ url: URL,
        body: Data?,
        headers: SwiftRestClient.Headers?,
        onCompletion: @escaping SwiftRestClient.RequestCompletion
    ) {
        postCalls.append((
            url: url,
            body: body,
            headers: headers,
            onCompletion: onCompletion
        ))

        onCompletion(data, response, error)
    }

    func clearMock() {
        data = nil
        response = nil
        error = nil
        getCalls.removeAll()
        postCalls.removeAll()
    }
}
