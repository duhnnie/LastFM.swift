import Foundation
import SwiftRestClient

public struct TrackModule {

    internal enum APIMethod: String, MethodKey {
        case scrobble = "scrobble"
        case love
        case unlove
        case updateNowPlaying
        case getInfo

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

    public func unlove(
        params: TrackLoveParams,
        onCompletion: @escaping (LastFMError?) -> Void
    ) throws {
        var payload = instance.normalizeParams(params: params, method: APIMethod.unlove)
        try instance.addSignature(params: &payload)

        try requester.postFormURLEncoded(
            payload: payload,
            secure: false,
            onCompletion: onCompletion
        )
    }

    public func updateNowPlaying(
        params: TrackNowPlayingParams,
        onCompletion: @escaping LastFM.OnCompletion<TrackPlayingNow>
    ) throws {
        var payload = instance.normalizeParams(params: params, method: APIMethod.updateNowPlaying)

        try instance.addSignature(params: &payload)

        try requester.postFormURLEncodedAndParse(
            payload: payload,
            secure: false,
            onCompletion: onCompletion
        )
    }

    public func getInfo(
        params: TrackInfoParams,
        onCompletion: @escaping LastFM.OnCompletion<TrackInfo>
    ) {
        let params = instance.normalizeParams(params: params, method: APIMethod.getInfo)

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

    public func getInfo(
        params: TrackInfoByMBIDParams,
        onCompletion: @escaping LastFM.OnCompletion<TrackInfo>
    ) {
        let params = instance.normalizeParams(params: params, method: APIMethod.getInfo)

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }
}
