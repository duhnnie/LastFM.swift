import Foundation
import SwiftRestClient

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@testable import LastFM

final internal class APIClientMock: APIClient, Mock {
    internal var data: Data?
    internal var response: URLResponse?
    internal var error: Error?

    private(set) var getCalls = [(
        url: URL,
        headers: SwiftRestClient.Headers?,
        onCompletion: SwiftRestClient.RequestCompletion
    )]()
    
    private(set) var asyncGetCalls = [(
        url: URL,
        headers: SwiftRestClient.Headers?
    )]()

    private(set) var postCalls = [(
        url: URL,
        body: Data?,
        headers: SwiftRestClient.Headers?,
        onCompletion: SwiftRestClient.RequestCompletion
    )]()
    
    private(set) var asyncPostCalls = [(
        url: URL,
        body: Data?,
        headers: SwiftRestClient.Headers?
    )]()
    
    func get(
        _ url: URL,
        headers: SwiftRestClient.Headers?
    ) async throws -> (Data, URLResponse) {
        asyncGetCalls.append((
            url: url,
            headers: headers
        ))

        if let error = error {
            throw error
        }
        
        return (data!, response!)
    }

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
        headers: SwiftRestClient.Headers?
    ) async throws -> (Data, URLResponse) {
        asyncPostCalls.append((
            url: url,
            body: body,
            headers: headers
        ))
        
        if let error = error {
            throw error
        }

        return (data!, response!)
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
