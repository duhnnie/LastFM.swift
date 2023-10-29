import Foundation
import SwiftRestClient

internal protocol Requester {

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

    func postFormURLEncoded(
        payload: [String: String],
        secure: Bool,
        onCompletion: @escaping (LastFMError?) -> Void
    ) throws

}
