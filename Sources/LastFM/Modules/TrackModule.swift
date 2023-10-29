import Foundation
import SwiftRestClient

public struct TrackModule {

    internal enum APIMethod: String, MethodKey {
        case scrobble = "scrobble"
        case love

        func getName() -> String {
            return "track.\(self.rawValue)"
        }
    }

    private let instance: LastFM
    private let requester: Requester

    internal init(instance: LastFM, requester: Requester = RequestUtils.shared) {
        self.instance = instance
        self.requester = requester
    }

    public func scrobble(
        params: ScrobbleParams,
        onCompletion: @escaping LastFM.OnCompletion<ScrobbleList>
    ) throws {
        var payload = instance.normalizeParams(params: params, method: APIMethod.scrobble)
        try instance.addSignature(params: &payload)

        try requester.postFormURLEncodedAndParse(
            payload: payload,
            secure: false,
            onCompletion: onCompletion
        )
    }

    public func love(
        params: TrackLoveParams,
        onCompletion: @escaping (LastFMError?) -> Void
    ) throws {
        var payload = instance.normalizeParams(params: params, method: APIMethod.love)
        try instance.addSignature(params: &payload)

        try requester.postFormURLEncoded(
            payload: payload,
            secure: false,
            onCompletion: onCompletion
        )
    }

}
