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
    private let secure: Bool

    internal init(parent: LastFM, secure: Bool, requester: Requester = RequestUtils.shared) {
        self.parent = parent
        self.requester = requester
        self.secure = secure
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getInfo(params: AlbumInfoParams) async throws -> AlbumInfo {
        let params = parent.normalizeParams(params: params, method: APIMethod.getInfo)

        return try await requester.getDataAndParse(
            params: params,
            type: AlbumInfo.self,
            secure: self.secure
        )
    }

    public func getInfo(
        params: AlbumInfoParams,
        onCompletion: @escaping LastFM.OnCompletion<AlbumInfo>
    ) {
        let params = parent.normalizeParams(params: params, method: APIMethod.getInfo)

        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getInfo(params: AlbumInfoByMBIDParams) async throws -> AlbumInfo {
        let params = parent.normalizeParams(params: params, method: APIMethod.getInfo)
        
        return try await requester.getDataAndParse(
            params: params,
            type: AlbumInfo.self,
            secure: self.secure
        )
    }

    public func getInfo(
        params: AlbumInfoByMBIDParams,
        onCompletion: @escaping LastFM.OnCompletion<AlbumInfo>
    ) {
        let params = parent.normalizeParams(params: params, method: APIMethod.getInfo)

        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func search(
        params: SearchParams
    ) async throws -> SearchResults<AlbumSearchResult> {
        let params = parent.normalizeParams(
            params: params.toDictionary(termKey: "album"),
            method: APIMethod.search
        )

        return try await requester.getDataAndParse(
            params: params,
            type: SearchResults<AlbumSearchResult>.self,
            secure: self.secure
        )
    }

    public func search(
        params: SearchParams,
        onCompletion: @escaping LastFM.OnCompletion<SearchResults<AlbumSearchResult>>
    ) {
        let params = parent.normalizeParams(
            params: params.toDictionary(termKey: "album"),
            method: APIMethod.search
        )

        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
    }

    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func addTags(
        params: AlbumAddTagsParams,
        sessionKey: String
    ) async throws {
        var payload = parent.normalizeParams(
            params: params,
            method: APIMethod.addTags,
            sessionKey: sessionKey
        )

        try parent.addSignature(params: &payload)
        try await requester.postFormURLEncoded(payload: payload, secure: self.secure)
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

        try requester.postFormURLEncoded(payload: payload, secure: self.secure, onCompletion: onCompletion)
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func removeTag(
        artist: String,
        album: String,
        tag: String,
        sessionKey: String
    ) async throws {
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
        try await requester.postFormURLEncoded(payload: payload, secure: self.secure)
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
        try requester.postFormURLEncoded(payload: payload, secure: self.secure, onCompletion: onCompletion)
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getTags(
        params: AlbumGetTagsParams
    ) async throws -> CollectionList<LastFMEntity> {
        let params = parent.normalizeParams(params: params, method: APIMethod.getTags)

        return try await requester.getDataAndParse(
            params: params,
            type: CollectionList<LastFMEntity>.self,
            secure: self.secure
        )
    }

    public func getTags(
        params: AlbumGetTagsParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionList<LastFMEntity>>
    ) {
        let params = parent.normalizeParams(params: params, method: APIMethod.getTags)

        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getTags(params: InfoByMBIDParams) async throws -> CollectionList<LastFMEntity> {
        var params = params.toDictionary()

        if let user = params["username"] {
            params["user"] = user
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

        if let user = params["username"] {
            params["user"] = user
            params.removeValue(forKey: "username")
        }

        params = parent.normalizeParams(params: params, method: APIMethod.getTags)
        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getTopTags(
        artist: String,
        album: String,
        autocorrect: Bool = true
    ) async throws -> CollectionList<TopTag> {
        let params = parent.normalizeParams(
            params: [
                "artist": artist,
                "album": album,
                "autocorrect": autocorrect ? "1" : "0"
            ],
            method: APIMethod.getTopTags
        )

        return try await requester.getDataAndParse(
            params: params,
            type: CollectionList<TopTag>.self,
            secure: self.secure
        )
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

        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getTopTags(
        mbid: String,
        autocorrect: Bool = true
    ) async throws -> CollectionList<TopTag> {
        let params = parent.normalizeParams(
            params: [
                "mbid": mbid,
                "autocorrect": autocorrect ? "1" : "0"
            ],
            method: APIMethod.getTopTags
        )
        
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
