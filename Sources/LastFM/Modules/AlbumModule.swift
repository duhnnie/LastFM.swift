import Foundation

public struct AlbumModule {

    internal enum APIMethod: String, MethodKey {
        case getInfo = "getinfo"
        case search
        case addTags = "addtags"
        case removeTag = "removetag"
        case getTags = "gettags"
        case getTopTags = "gettoptags"

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
        params: AlbumAddTagsParams,
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

    public func getTags(
        params: AlbumGetTagsParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionList<LastFMEntity>>
    ) {
        let params = parent.normalizeParams(params: params, method: APIMethod.getTags)

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

    public func getTags(
        params: InfoByMBIDParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionList<LastFMEntity>>
    ) {
        var params = params.toDictionary()

        if let user = params["username"] {
            params["user"] = user
            params.removeValue(forKey: "username")
        }

        params = parent.normalizeParams(params: params, method: APIMethod.getTags)
        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

    public func getTopTags(
        artist: String,
        album: String,
        autocorrect: Bool = true,
        onCompletion: @escaping LastFM.OnCompletion<CollectionList<TopTag>>
    ) {
        let params = parent.normalizeParams(
            params: [
                "artist": artist,
                "album": album,
                "autocorrect": autocorrect ? "1" : "0"
            ],
            method: APIMethod.getTopTags
        )

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

    public func getTopTags(
        mbid: String,
        autocorrect: Bool = true,
        onCompletion: @escaping LastFM.OnCompletion<CollectionList<TopTag>>
    ) {
        let params = parent.normalizeParams(
            params: [
                "mbid": mbid,
                "autocorrect": autocorrect ? "1" : "0"
            ],
            method: APIMethod.getTopTags
        )

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }
    
}
