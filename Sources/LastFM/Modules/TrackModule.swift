import Foundation
import SwiftRestClient

public struct TrackModule {

    internal enum APIMethod: String, MethodKey {
        case scrobble = "scrobble"
        case love
        case unlove
        case updateNowPlaying
        case getInfo
        case search
        case addTags = "addtags"

        func getName() -> String {
            return "track.\(self.rawValue)"
        }
    }

    private let parent: LastFM
    private let requester: Requester

    internal init(parent: LastFM, requester: Requester = RequestUtils.shared) {
        self.parent = parent
        self.requester = requester
    }

    public func scrobble(
        params: ScrobbleParams,
        sessionKey: String,
        onCompletion: @escaping LastFM.OnCompletion<ScrobbleList>
    ) throws {
        var payload = parent.normalizeParams(
            params: params,
            sessionKey: sessionKey,
            method: APIMethod.scrobble
        )
        
        try parent.addSignature(params: &payload)

        try requester.postFormURLEncodedAndParse(
            payload: payload,
            secure: false,
            onCompletion: onCompletion
        )
    }

    public func love(
        params: TrackParams,
        sessionKey: String,
        onCompletion: @escaping (LastFMError?) -> Void
    ) throws {
        var payload = parent.normalizeParams(
            params: params,
            sessionKey: sessionKey,
            method: APIMethod.love
        )
        try parent.addSignature(params: &payload)

        try requester.postFormURLEncoded(
            payload: payload,
            secure: false,
            onCompletion: onCompletion
        )
    }

    public func unlove(
        params: TrackParams,
        sessionKey: String,
        onCompletion: @escaping (LastFMError?) -> Void
    ) throws {
        var payload = parent.normalizeParams(
            params: params,
            sessionKey: sessionKey,
            method: APIMethod.unlove
        )

        try parent.addSignature(params: &payload)

        try requester.postFormURLEncoded(
            payload: payload,
            secure: false,
            onCompletion: onCompletion
        )
    }

    public func updateNowPlaying(
        params: TrackNowPlayingParams,
        sessionKey: String,
        onCompletion: @escaping LastFM.OnCompletion<TrackPlayingNow>
    ) throws {
        var payload = parent.normalizeParams(
            params: params,
            sessionKey: sessionKey,
            method: APIMethod.updateNowPlaying
        )

        try parent.addSignature(params: &payload)

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
        let params = parent.normalizeParams(params: params, method: APIMethod.getInfo)

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

    public func getInfo(
        params: TrackInfoByMBIDParams,
        onCompletion: @escaping LastFM.OnCompletion<TrackInfo>
    ) {
        let params = parent.normalizeParams(params: params, method: APIMethod.getInfo)

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

    public func search(
        params: TrackSearchParams,
        onCompletion: @escaping LastFM.OnCompletion<SearchResults<TrackSearchResult>>
    ) {
        let params = parent.normalizeParams(params: params, method: APIMethod.search)

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

    public func addTags(
        params: TrackTagsParams,
        sessionKey: String,
        onCompletion: @escaping (LastFMError?) -> Void
    ) throws {
        var params = parent.normalizeParams(params: params, sessionKey: sessionKey, method: APIMethod.addTags)

        try parent.addSignature(params: &params)
        try requester.postFormURLEncoded(payload: params, secure: false, onCompletion: onCompletion)
    }

}
