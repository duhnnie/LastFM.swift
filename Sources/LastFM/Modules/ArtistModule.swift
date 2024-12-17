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
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    private func internalGetTopTracks(params: Params) async throws -> CollectionPage<ArtistTopTrack> {
        return try await withCheckedThrowingContinuation({ continuation in
            self.internalGetTopTracks(params: params) { result in
                switch (result) {
                case .success(let artistTopTracks):
                    continuation.resume(returning: artistTopTracks)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        })
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getTopTracks(params: ArtistTopItemsParams) async throws -> CollectionPage<ArtistTopTrack> {
        return try await self.internalGetTopTracks(params: params)
    }

    public func getTopTracks(
        params: ArtistTopItemsParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<ArtistTopTrack>>
    ) {
        self.internalGetTopTracks(params: params, onCompletion: onCompletion)
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getTopTracks(params: MBIDPageParams) async throws -> CollectionPage<ArtistTopTrack> {
        return try await self.internalGetTopTracks(params: params)
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
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    private func internalGetSimilar(params: Params) async throws -> CollectionList<ArtistSimilar> {
        let params = parent.normalizeParams(params: params, method: APIMethod.getSimilar)
        
        return try await requester.getDataAndParse(
            params: params,
            type: CollectionList<ArtistSimilar>.self,
            secure: self.secure
        )
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getSimilar(params: ArtistSimilarParams) async throws -> CollectionList<ArtistSimilar> {
        return try await self.internalGetSimilar(params: params)
    }

    public func getSimilar(
        params: ArtistSimilarParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionList<ArtistSimilar>>
    ) {
        self.internalGetSimilar(params: params, onCompletion: onCompletion)
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getSimilar(params: MBIDListParams) async throws -> CollectionList<ArtistSimilar> {
        return try await self.internalGetSimilar(params: params)
    }

    public func getSimilar(
        params: MBIDListParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionList<ArtistSimilar>>
    ) {
        self.internalGetSimilar(params: params, onCompletion: onCompletion)
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func search(params: SearchParams) async throws -> SearchResults<ArtistSearchResult> {
        let params = parent.normalizeParams(
            params: params.toDictionary(termKey: "artist"),
            method: APIMethod.search
        )

        return try await requester.getDataAndParse(
            params: params,
            type: SearchResults<ArtistSearchResult>.self,
            secure: self.secure
        )
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
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    private func internalGetTopAlbums(params: Params) async throws -> CollectionPage<ArtistTopAlbum> {
        let params = parent.normalizeParams(params: params, method: APIMethod.getTopAlbums)

        return try await requester.getDataAndParse(
            params: params,
            type: CollectionPage<ArtistTopAlbum>.self,
            secure: self.secure
        )
    }

    private func internalGetTopAlbums(
        params: Params,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<ArtistTopAlbum>>
    ) {
        let params = parent.normalizeParams(params: params, method: APIMethod.getTopAlbums)

        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getTopAlbums(params: ArtistTopItemsParams) async throws -> CollectionPage<ArtistTopAlbum> {
        return try await internalGetTopAlbums(params: params)
    }

    public func getTopAlbums(
        params: ArtistTopItemsParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<ArtistTopAlbum>>
    ) {
        self.internalGetTopAlbums(params: params, onCompletion: onCompletion)
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getTopAlbums(params: MBIDPageParams) async throws -> CollectionPage<ArtistTopAlbum> {
        return try await internalGetTopAlbums(params: params)
    }

    public func getTopAlbums(
        params: MBIDPageParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<ArtistTopAlbum>>
    ) {
        self.internalGetTopAlbums(params: params, onCompletion: onCompletion)
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getInfo(
        params: ArtistInfoParams
    ) async throws -> ArtistInfo {
        let params = parent.normalizeParams(params: params, method: APIMethod.getInfo)

        return try await requester.getDataAndParse(params: params, type: ArtistInfo.self, secure: self.secure)
    }

    public func getInfo(
        params: ArtistInfoParams,
        onCompletion: @escaping LastFM.OnCompletion<ArtistInfo>
    ) {
        let params = parent.normalizeParams(params: params, method: APIMethod.getInfo)

        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func addTags(
        artist: String,
        tags: [String],
        sessionKey: String
    ) async throws {
        return try await withCheckedThrowingContinuation({ continuation in
            do {
                try self.addTags(artist: artist, tags: tags, sessionKey: sessionKey) { error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(returning: ())
                    }
                }
            } catch {
                continuation.resume(throwing: error)
            }
        })
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
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func removeTag(
        artist: String,
        tag: String,
        sessionKey: String
    ) async throws {
        return try await withCheckedThrowingContinuation({ continuation in
            do {
                try self.removeTag(artist: artist, tag: tag, sessionKey: sessionKey) { error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(returning: ())
                    }
                }
            } catch {
                continuation.resume(throwing: error)
            }
        })
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
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getCorrection(artist: String) async throws -> ArtistCorrection {
        return try await withCheckedThrowingContinuation({ continuation in
            self.getCorrection(artist: artist) { result in
                switch (result) {
                case .success(let artistCorrection):
                    continuation.resume(returning: artistCorrection)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        })
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
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getTags(params: ArtistTagsParams) async throws -> CollectionList<LastFMEntity> {
        let params = parent.normalizeParams(params: params, method: APIMethod.getTags)

        return try await requester.getDataAndParse(params: params, type: CollectionList<LastFMEntity>.self, secure: self.secure)
    }

    public func getTags(
        params: ArtistTagsParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionList<LastFMEntity>>
    ) {
        let params = parent.normalizeParams(params: params, method: APIMethod.getTags)

        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getTags(params: InfoByMBIDParams) async throws -> CollectionList<LastFMEntity> {
        return try await withCheckedThrowingContinuation({ continuation in
            self.getTags(params: params) { result in
                switch (result) {
                case .success(let tags):
                    continuation.resume(returning: tags)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        })
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
    public func getTopTags(artist: String, autocorrect: Bool = true) async throws -> CollectionList<TopTag> {
        return try await withCheckedThrowingContinuation({ continuation in
            self.getTopTags(artist: artist) { result in
                switch (result) {
                case .success(let topTags):
                    continuation.resume(returning: topTags)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        })
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
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getTopTags(mbid: String, autocorrect: Bool = true) async throws -> CollectionList<TopTag> {
        return try await withCheckedThrowingContinuation({ continuation in
            self.getTopTags(mbid: mbid, autocorrect: autocorrect) { result in
                switch result {
                case .success(let topTags):
                    continuation.resume(returning: topTags)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        })
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
