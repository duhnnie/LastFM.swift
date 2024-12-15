import Foundation

public struct ArtistModule {

    internal enum APIMethod: String, MethodKey {
        case getTopTracks = "gettoptracks"
        case getSimilar = "getsimilar"
        case search
        case getTopAlbums = "gettopalbums"
        case getInfo = "getInfo"
        case addTags = "addtags"
        case removeTag = "removetag"
        case getCorrection = "getcorrection"
        case getTags = "gettags"
        case getTopTags = "gettoptags"

        func getName() -> String {
            return "artist.\(self.rawValue)"
        }
    }

    private let parent: LastFM
    private let requester: Requester
    private let secure: Bool

    internal init(parent: LastFM, secure: Bool,  requester: Requester = RequestUtils.shared) {
        self.parent = parent
        self.requester = requester
        self.secure = secure
    }

    private func internalGetTopTracks(
        params: Params,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<ArtistTopTrack>>
    ) {
        let params = parent.normalizeParams(params: params, method: APIMethod.getTopTracks)

        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
    }

    public func getTopTracks(
        params: ArtistTopItemsParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<ArtistTopTrack>>
    ) {
        self.internalGetTopTracks(params: params, onCompletion: onCompletion)
    }

    public func getTopTracks(
        params: MBIDPageParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<ArtistTopTrack>>
    ) {
        self.internalGetTopTracks(params: params, onCompletion: onCompletion)
    }

    private func internalGetSimilar(
        params: Params,
        onCompletion: @escaping LastFM.OnCompletion<CollectionList<ArtistSimilar>>
    ) {
        let params = parent.normalizeParams(params: params, method: APIMethod.getSimilar)

        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
    }

    public func getSimilar(
        params: ArtistSimilarParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionList<ArtistSimilar>>
    ) {
        self.internalGetSimilar(params: params, onCompletion: onCompletion)
    }

    public func getSimilar(
        params: MBIDListParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionList<ArtistSimilar>>
    ) {
        self.internalGetSimilar(params: params, onCompletion: onCompletion)
    }

    public func search(
        params: SearchParams,
        onCompletion: @escaping LastFM.OnCompletion<SearchResults<ArtistSearchResult>>
    ) {
        let params = parent.normalizeParams(
            params: params.toDictionary(termKey: "artist"),
            method: APIMethod.search
        )

        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
    }

    private func internalGetTopAlbums(
        params: Params,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<ArtistTopAlbum>>
    ) {
        let params = parent.normalizeParams(params: params, method: APIMethod.getTopAlbums)

        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
    }

    public func getTopAlbums(
        params: ArtistTopItemsParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<ArtistTopAlbum>>
    ) {
        self.internalGetTopAlbums(params: params, onCompletion: onCompletion)
    }

    public func getTopAlbums(
        params: MBIDPageParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<ArtistTopAlbum>>
    ) {
        self.internalGetTopAlbums(params: params, onCompletion: onCompletion)
    }

    public func getInfo(
        params: ArtistInfoParams,
        onCompletion: @escaping LastFM.OnCompletion<ArtistInfo>
    ) {
        let params = parent.normalizeParams(params: params, method: APIMethod.getInfo)

        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
    }

    public func addTags(
        artist: String,
        tags: [String],
        sessionKey: String,
        onCompletion: @escaping (LastFMError?) -> Void
    ) throws {
        var params = parent.normalizeParams(
            params: [
                "artist": artist,
                "tags": tags.joined(separator: ",")
            ],
            method: APIMethod.addTags,
            sessionKey: sessionKey
        )

        try parent.addSignature(params: &params)
        try requester.postFormURLEncoded(payload: params, secure: self.secure, onCompletion: onCompletion)
    }

    public func removeTag(
        artist: String,
        tag: String,
        sessionKey: String,
        onCompletion: @escaping (LastFMError?) -> Void
    ) throws {
        var params = parent.normalizeParams(
            params: [
                "artist": artist,
                "tags": tag
            ],
            method: APIMethod.removeTag,
            sessionKey: sessionKey
        )

        try parent.addSignature(params: &params)
        try requester.postFormURLEncoded(payload: params, secure: self.secure, onCompletion: onCompletion)
    }

    public func getCorrection(
        artist: String,
        onCompletion: @escaping LastFM.OnCompletion<ArtistCorrection>
    ) {
        let params = parent.normalizeParams(
            params: ["artist": artist],
            method: APIMethod.getCorrection
        )

        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
    }

    public func getTags(
        params: ArtistTagsParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionList<LastFMEntity>>
    ) {
        let params = parent.normalizeParams(params: params, method: APIMethod.getTags)

        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
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

    public func getTopTags(
        artist: String,
        autocorrect: Bool = true,
        onCompletion: @escaping LastFM.OnCompletion<CollectionList<TopTag>>
    ) {
        let params = parent.normalizeParams(
            params: [
                "artist": artist,
                "autocorrect": autocorrect ? "1" : "0"
            ],
            method: APIMethod.getTopTags
        )

        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
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

        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
    }

}
