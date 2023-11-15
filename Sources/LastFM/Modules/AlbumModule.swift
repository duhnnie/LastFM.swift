import Foundation

public struct AlbumModule {

    internal enum APIMethod: String, MethodKey {
        case getInfo = "getinfo"
        case search
        case addTags = "addtags"
        case removeTag = "removetag"

        func getName() -> String {
            return "album.\(self.rawValue)"
        }
    }

    private let parent: LastFM
    private let requester: Requester

    internal init(parent: LastFM, requester: Requester = RequestUtils.shared) {
        self.parent = parent
        self.requester = requester
    }

    public func getInfo(
        params: AlbumInfoParams,
        onCompletion: @escaping LastFM.OnCompletion<AlbumInfo>
    ) {
        let params = parent.normalizeParams(params: params, method: APIMethod.getInfo)

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

    public func getInfo(
        params: AlbumInfoByMBIDParams,
        onCompletion: @escaping LastFM.OnCompletion<AlbumInfo>
    ) {
        let params = parent.normalizeParams(params: params, method: APIMethod.getInfo)

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

    public func search(
        params: SearchParams,
        onCompletion: @escaping LastFM.OnCompletion<SearchResults<AlbumSearchResult>>
    ) {
        let params = parent.normalizeParams(
            params: params.toDictionary(termKey: "album"),
            method: APIMethod.search
        )

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

    public func addTags(
        params: AlbumTagsParams,
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
        album: String,
        tag: String,
        sessionKey: String,
        onCompletion: @escaping (LastFMError?) -> Void
    ) throws {
        var payload = parent.normalizeParams(
            params: [
                "artist": artist,
                "album": album,
                "tag": tag
            ],
            method: APIMethod.removeTag,
            sessionKey: sessionKey
        )

        try parent.addSignature(params: &payload)
        try requester.postFormURLEncoded(payload: payload, secure: false, onCompletion: onCompletion)
    }
    
}
