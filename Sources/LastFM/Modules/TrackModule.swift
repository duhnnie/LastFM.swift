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
        case getTags = "gettags"
        case getTopTags = "gettoptags"

        func getName() -> String {
            return "track.\(self.rawValue)"
        }
    }

    private let parent: LastFM
    private let requester: Requester
    private let secure: Bool

    internal init(parent: LastFM, secure: Bool, requester: Requester = RequestUtils.shared) {
        self.parent = parent
        self.requester = requester
        self.secure = secure
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func scrobble(params: ScrobbleParams, sessionKey: String) async throws -> ScrobbleList {
        var payload = parent.normalizeParams(
            params: params,
            method: APIMethod.scrobble,
            sessionKey: sessionKey
        )
        
        try parent.addSignature(params: &payload)

        return try await requester.postFormURLEncodedAndParse(
            payload: payload,
            type: ScrobbleList.self,
            secure: self.secure
        )
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
            secure: self.secure,
            onCompletion: onCompletion
        )
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func love(params: TrackParams, sessionKey: String) async throws {
        var payload = parent.normalizeParams(
            params: params,
            method: APIMethod.love,
            sessionKey: sessionKey
        )
        
        try parent.addSignature(params: &payload)
        
        return try await requester.postFormURLEncoded(payload: payload, secure: self.secure)
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
            secure: self.secure,
            onCompletion: onCompletion
        )
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func unlove(params: TrackParams, sessionKey: String) async throws {
        var payload = parent.normalizeParams(
            params: params,
            method: APIMethod.unlove,
            sessionKey: sessionKey
        )

        try parent.addSignature(params: &payload)
        
        return try await requester.postFormURLEncoded(payload: payload, secure: self.secure)
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
            secure: self.secure,
            onCompletion: onCompletion
        )
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func updateNowPlaying(params: TrackNowPlayingParams, sessionKey: String) async throws -> TrackPlayingNow {
        var payload = parent.normalizeParams(
            params: params,
            method: APIMethod.updateNowPlaying,
            sessionKey: sessionKey
        )

        try parent.addSignature(params: &payload)

        return try await requester.postFormURLEncodedAndParse(payload: payload, type: TrackPlayingNow.self, secure: self.secure)
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
            secure: self.secure,
            onCompletion: onCompletion
        )
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getInfo(params: TrackInfoParams) async throws -> TrackInfo {
        let params = parent.normalizeParams(params: params, method: APIMethod.getInfo)

        return try await requester.getDataAndParse(params: params, type: TrackInfo.self, secure: self.secure)
    }

    public func getInfo(
        params: TrackInfoParams,
        onCompletion: @escaping LastFM.OnCompletion<TrackInfo>
    ) {
        let params = parent.normalizeParams(params: params, method: APIMethod.getInfo)

        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getInfo(params: InfoByMBIDParams) async throws -> TrackInfo {
        let params = parent.normalizeParams(params: params, method: APIMethod.getInfo)

        return try await requester.getDataAndParse(params: params, type: TrackInfo.self, secure: self.secure)
    }

    public func getInfo(
        params: InfoByMBIDParams,
        onCompletion: @escaping LastFM.OnCompletion<TrackInfo>
    ) {
        let params = parent.normalizeParams(params: params, method: APIMethod.getInfo)

        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
    }

    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func search(
        params: TrackSearchParams
    ) async throws -> SearchResults<TrackSearchResult> {
        let params = parent.normalizeParams(params: params, method: APIMethod.search)

        return try await requester.getDataAndParse(params: params, type: SearchResults<TrackSearchResult>.self, secure: self.secure)
    }

    public func search(
        params: TrackSearchParams,
        onCompletion: @escaping LastFM.OnCompletion<SearchResults<TrackSearchResult>>
    ) {
        let params = parent.normalizeParams(params: params, method: APIMethod.search)

        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func addTags(params: TrackTagsParams, sessionKey: String) async throws {
        var payload = parent.normalizeParams(
            params: params,
            method: APIMethod.addTags,
            sessionKey: sessionKey
        )

        try parent.addSignature(params: &payload)

        return try await requester.postFormURLEncoded(payload: payload, secure: self.secure)
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
        try requester.postFormURLEncoded(payload: payload, secure: self.secure, onCompletion: onCompletion)
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func removeTag(
        artist: String,
        track: String,
        tag: String,
        sessionKey: String
    ) async throws {
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
        
        return try await requester.postFormURLEncoded(payload: payload, secure: self.secure)
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
        try requester.postFormURLEncoded(payload: payload, secure: self.secure, onCompletion: onCompletion)
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getCorrection(artist: String, track: String) async throws -> TrackCorrection {
        let params = parent.normalizeParams(
            params: ["artist": artist, "track": track],
            method: APIMethod.getCorrection
        )

        return try await requester.getDataAndParse(params: params, type: TrackCorrection.self, secure: self.secure)
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

        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getSimilar(params: TrackSimilarParams) async throws -> CollectionList<TrackSimilar> {
        let params = parent.normalizeParams(params: params, method: APIMethod.getSimilar)

        return try await requester.getDataAndParse(params: params, type: CollectionList<TrackSimilar>.self, secure: self.secure)
    }

    public func getSimilar(
        params: TrackSimilarParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionList<TrackSimilar>>
    ) {
        let params = parent.normalizeParams(params: params, method: APIMethod.getSimilar)

        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getSimilar(params: MBIDListParams) async throws -> CollectionList<TrackSimilar> {
        let params = parent.normalizeParams(params: params, method: APIMethod.getSimilar)

        return try await requester.getDataAndParse(params: params, type: CollectionList<TrackSimilar>.self, secure: self.secure)
    }

    public func getSimilar(
        params: MBIDListParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionList<TrackSimilar>>
    ) {
        let params = parent.normalizeParams(params: params, method: APIMethod.getSimilar)

        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getTags(params: TrackInfoParams) async throws -> CollectionList<LastFMEntity> {
        var params = params.toDictionary()

        if let username = params["username"] {
            params["user"] = username
            params.removeValue(forKey: "username")
        }

        params = parent.normalizeParams(params: params, method: APIMethod.getTags)

        return try await requester.getDataAndParse(params: params, type: CollectionList<LastFMEntity>.self, secure: self.secure)
    }

    public func getTags(
        params: TrackInfoParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionList<LastFMEntity>>
    ) {
        var params = params.toDictionary()

        if let username = params["username"] {
            params["user"] = username
            params.removeValue(forKey: "username")
        }

        params = parent.normalizeParams(params: params, method: APIMethod.getTags)

        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
    }

    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getTags(params: InfoByMBIDParams) async throws -> CollectionList<LastFMEntity> {
        var params = params.toDictionary()

        if let username = params["username"] {
            params["user"] = username
            params.removeValue(forKey: "username")
        }

        params = parent.normalizeParams(params: params, method: APIMethod.getTags)

        return try await requester.getDataAndParse(
            params: params,
            type: CollectionList<LastFMEntity>.self,
            secure: self.secure
        )
    }
    
    public func getTags(
        params: InfoByMBIDParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionList<LastFMEntity>>
    ) {
        var params = params.toDictionary()

        if let username = params["username"] {
            params["user"] = username
            params.removeValue(forKey: "username")
        }

        params = parent.normalizeParams(params: params, method: APIMethod.getTags)

        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getTopTags(
        params: TrackParams,
        autocorrect: Bool = true
    ) async throws -> CollectionList<TopTag> {
        var params = params.toDictionary()

        params["autocorrect"] = autocorrect ? "1" : "0"
        params = parent.normalizeParams(params: params, method: APIMethod.getTopTags)
        
        return try await requester.getDataAndParse(
            params: params,
            type: CollectionList<TopTag>.self,
            secure: self.secure
        )
    }

    public func getTopTags(
        params: TrackParams,
        autocorrect: Bool = true,
        onCompletion: @escaping LastFM.OnCompletion<CollectionList<TopTag>>
    ) {
        var params = params.toDictionary()

        params["autocorrect"] = autocorrect ? "1" : "0"
        params = parent.normalizeParams(params: params, method: APIMethod.getTopTags)
        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getTopTags(
        mbid: String,
        autocorrect: Bool = true
    ) async throws -> CollectionList<TopTag> {
        var params = [
            "mbid": mbid,
            "autocorrect": autocorrect ? "1" : "0"
        ]

        params = parent.normalizeParams(params: params, method: APIMethod.getTopTags)
        
        return try await requester.getDataAndParse(
            params: params,
            type: CollectionList<TopTag>.self,
            secure: self.secure
        )
    }

    public func getTopTags(
        mbid: String,
        autocorrect: Bool = true,
        onCompletion: @escaping LastFM.OnCompletion<CollectionList<TopTag>>
    ) {
        var params = [
            "mbid": mbid,
            "autocorrect": autocorrect ? "1" : "0"
        ]

        params = parent.normalizeParams(params: params, method: APIMethod.getTopTags)
        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
    }

}
