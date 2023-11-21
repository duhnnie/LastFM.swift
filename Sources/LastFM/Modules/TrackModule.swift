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
        case removeTag = "removetag"
        case getCorrection = "getcorrection"
        case getSimilar = "getsimilar"

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
            method: APIMethod.scrobble,
            sessionKey: sessionKey
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
            method: APIMethod.love,
            sessionKey: sessionKey
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
            method: APIMethod.unlove,
            sessionKey: sessionKey
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
            method: APIMethod.updateNowPlaying,
            sessionKey: sessionKey
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
        var payload = parent.normalizeParams(
            params: params,
            method: APIMethod.addTags,
            sessionKey: sessionKey
        )

        try parent.addSignature(params: &payload)
        try requester.postFormURLEncoded(payload: payload, secure: false, onCompletion: onCompletion)
    }

    public func removeTag(
        artist: String,
        track: String,
        tag: String,
        sessionKey: String,
        onCompletion: @escaping (LastFMError?) -> Void
    ) throws {
        var payload = parent.normalizeParams(
            params: [
                "artist": artist,
                "track": track,
                "tag": tag,
            ],
            method: APIMethod.removeTag,
            sessionKey: sessionKey
        )

        try parent.addSignature(params: &payload)
        try requester.postFormURLEncoded(payload: payload, secure: false, onCompletion: onCompletion)
    }

    public func getCorrection(
        artist: String,
        track: String,
        onCompletion: @escaping LastFM.OnCompletion<TrackCorrection>
    ) {
        let params = parent.normalizeParams(
            params: ["artist": artist, "track": track],
            method: APIMethod.getCorrection
        )

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

    public func getSimilar(
        params: TrackSimilarParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionList<TrackSimilar>>
    ) {
        let params = parent.normalizeParams(params: params, method: APIMethod.getSimilar)

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

    public func getSimilar(
        params: TrackSimilarByMBIDParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionList<TrackSimilar>>
    ) {
        let params = parent.normalizeParams(params: params, method: APIMethod.getSimilar)

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

}
