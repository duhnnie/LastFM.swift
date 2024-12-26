import Foundation
import SwiftRestClient

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

internal protocol APIClient {
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func get(
        _ url: URL,
        headers: SwiftRestClient.Headers?
    ) async throws -> (Data, URLResponse)

    func get(
        _ url: URL,
        headers: SwiftRestClient.Headers?,
        onCompletion: @escaping SwiftRestClient.RequestCompletion
    )
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func post(
        _ url: URL,
        body: Data?,
        headers: SwiftRestClient.Headers?
    ) async throws -> (Data, URLResponse)

    func post(
        _ url: URL,
        body: Data?,
        headers: SwiftRestClient.Headers?,
        onCompletion: @escaping SwiftRestClient.RequestCompletion
    )

}
