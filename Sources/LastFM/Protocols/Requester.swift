import Foundation
import SwiftRestClient

internal protocol Requester {
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func getDataAndParse<T: Decodable>(
        params: [String: String],
        type: T.Type,
        secure: Bool
    ) async throws -> T
    
    func getDataAndParse<T: Decodable>(
        params: [String: String],
        secure: Bool,
        onCompletion: @escaping LastFM.OnCompletion<T>
    )

    func postFormURLEncodedAndParse<T: Decodable>(
        payload: [String: String],
        secure: Bool,
        onCompletion: @escaping LastFM.OnCompletion<T>
    ) throws
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func postFormURLEncoded(
        payload: [String: String],
        secure: Bool
    ) async throws

    func postFormURLEncoded(
        payload: [String: String],
        secure: Bool,
        onCompletion: @escaping (LastFMError?) -> Void
    ) throws

}
