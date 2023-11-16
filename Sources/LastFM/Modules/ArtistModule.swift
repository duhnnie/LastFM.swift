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

        func getName() -> String {
            return "artist.\(self.rawValue)"
        }
    }

    private let parent: LastFM
    private let requester: Requester

    internal init(parent: LastFM, requester: Requester = RequestUtils.shared) {
        self.parent = parent
        self.requester = requester
    }

    public func getTopTracks(
        params: ArtistTopTracksParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<ArtistTopTrack>>
    ) {
        let params = parent.normalizeParams(params: params, method: APIMethod.getTopTracks)

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

    public func getSimilar(
        params: ArtistSimilarParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionList<ArtistSimilar>>
    ) {
        let params = parent.normalizeParams(params: params, method: APIMethod.getSimilar)

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

    public func search(
        params: SearchParams,
        onCompletion: @escaping LastFM.OnCompletion<SearchResults<ArtistSearchResult>>
    ) {
        let params = parent.normalizeParams(
            params: params.toDictionary(termKey: "artist"),
            method: APIMethod.search
        )

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

    public func getTopAlbums(
        params: ArtistTopAlbumsParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<ArtistTopAlbum>>
    ) {
        let params = parent.normalizeParams(params: params, method: APIMethod.getTopAlbums)

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

    public func getInfo(
        params: ArtistInfoParams,
        onCompletion: @escaping LastFM.OnCompletion<ArtistInfo>
    ) {
        let params = parent.normalizeParams(params: params, method: APIMethod.getInfo)

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
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
        try requester.postFormURLEncoded(payload: params, secure: false, onCompletion: onCompletion)
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
        try requester.postFormURLEncoded(payload: params, secure: false, onCompletion: onCompletion)
    }

    public func getCorrection(
        artist: String,
        onCompletion: @escaping LastFM.OnCompletion<ArtistCorrection>
    ) {
        let params = parent.normalizeParams(
            params: ["artist": artist],
            method: APIMethod.getCorrection
        )

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

}
