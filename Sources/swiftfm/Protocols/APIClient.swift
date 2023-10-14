import Foundation
import SwiftRestClient

internal protocol APIClient {

    func get(
        _ url: URL,
        headers: SwiftRestClient.Headers?,
        onCompletion: @escaping SwiftRestClient.RequestCompletion
    )

    func post(
        _ url: URL,
        body: Data?,
        headers: SwiftRestClient.Headers?,
        onCompletion: @escaping SwiftRestClient.RequestCompletion
    )

}
