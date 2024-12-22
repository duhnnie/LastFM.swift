import Foundation

public struct TagModule {

    internal enum APIMethod: String, MethodKey {
        case getTopTracks = "gettoptracks"
        case getTopArtists = "gettopartists"
        case getTopAlbums = "gettopalbums"
        case getInfo = "getinfo"
        case getWeeklyChartList = "getweeklychartlist"
        case getSimilar = "getsimilar"
        case getTopTags = "gettoptags"

        func getName() -> String {
            return "tag.\(self.rawValue)"
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
    public func getTopTracks(params: SearchParams) async throws -> CollectionPage<TagTopTrack> {
        let params = parent.normalizeParams(
            params: params.toDictionary(termKey: "tag"),
            method: APIMethod.getTopTracks
        )

        return try await requester.getDataAndParse(
            params: params,
            type: CollectionPage<TagTopTrack>.self,
            secure: self.secure
        )
    }

    public func getTopTracks(
        params: SearchParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<TagTopTrack>>
    ) {
        let params = parent.normalizeParams(
            params: params.toDictionary(termKey: "tag"),
            method: APIMethod.getTopTracks
        )

        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getTopArtists(params: SearchParams) async throws -> CollectionPage<TagTopArtist> {
        let params = parent.normalizeParams(
            params: params.toDictionary(termKey: "tag"),
            method: APIMethod.getTopArtists
        )

        return try await requester.getDataAndParse(
            params: params,
            type: CollectionPage<TagTopArtist>.self,
            secure: self.secure
        )
    }

    public func getTopArtists(
        params: SearchParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<TagTopArtist>>
    ) {
        let params = parent.normalizeParams(
            params: params.toDictionary(termKey: "tag"),
            method: APIMethod.getTopArtists
        )

        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
    }

    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getTopAlbums(params: SearchParams) async throws -> CollectionPage<TagTopAlbum> {
        let params = parent.normalizeParams(
            params: params.toDictionary(termKey: "tag"),
            method: APIMethod.getTopAlbums
        )

        return try await requester.getDataAndParse(params: params, type: CollectionPage<TagTopAlbum>.self, secure: self.secure)
    }

    public func getTopAlbums(
        params: SearchParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<TagTopAlbum>>
    ) {
        let params = parent.normalizeParams(
            params: params.toDictionary(termKey: "tag"),
            method: APIMethod.getTopAlbums
        )

        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getInfo(name: String, lang: String? = nil) async throws -> TagInfo {
        var params = ["name": name]

        if let lang = lang {
            params["lang"] = lang
        }

        let normalizedParams = parent.normalizeParams(params: params, method: APIMethod.getInfo)
        
        return try await requester.getDataAndParse(
            params: normalizedParams,
            type: TagInfo.self,
            secure: self.secure
        )
    }

    public func getInfo(
        name: String,
        lang: String? = nil,
        onCompletion: @escaping LastFM.OnCompletion<TagInfo>
    ) {
        var params = ["name": name]

        if let lang = lang {
            params["lang"] = lang
        }

        let normalizedParams = parent.normalizeParams(params: params, method: APIMethod.getInfo)

        requester.getDataAndParse(
            params: normalizedParams,
            secure: self.secure,
            onCompletion: onCompletion
        )
    }

    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getWeeklyChartList(tag: String) async throws -> CollectionList<ChartDateRange> {
        let params = parent.normalizeParams(
            params: ["tag": tag],
            method: APIMethod.getWeeklyChartList
        )

        return try await requester.getDataAndParse(
            params: params,
            type: CollectionList<ChartDateRange>.self,
            secure: self.secure
        )
    }
    
    public func getWeeklyChartList(
        tag: String,
        onCompletion: @escaping LastFM.OnCompletion<CollectionList<ChartDateRange>>
    ) {
        let params = parent.normalizeParams(
            params: ["tag": tag],
            method: APIMethod.getWeeklyChartList
        )

        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getSimilar(tag: String) async throws -> CollectionList<SimilarTag> {
        let params = parent.normalizeParams(
            params: ["tag": tag],
            method: APIMethod.getSimilar
        )

        return try await requester.getDataAndParse(
            params: params,
            type: CollectionList<SimilarTag>.self,
            secure: self.secure
        )
    }

    public func getSimilar(
        tag: String,
        onCompletion: @escaping LastFM.OnCompletion<CollectionList<SimilarTag>>
    ) {
        let params = parent.normalizeParams(
            params: ["tag": tag],
            method: APIMethod.getSimilar
        )

        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getTopTags(
        offset: UInt = 0,
        limit: UInt = 10
    ) async throws -> CollectionList<TopGlobalTag> {
        let params = parent.normalizeParams(
            params: [
                "offset": String(offset),
                "num_res": String(limit)
            ],
            method: APIMethod.getTopTags
        )

        return try await requester.getDataAndParse(
            params: params,
            type: CollectionList<TopGlobalTag>.self,
            secure: self.secure
        )
    }

    public func getTopTags(
        offset: UInt = 0,
        limit: UInt = 10,
        onCompletion: @escaping LastFM.OnCompletion<CollectionList<TopGlobalTag>>
    ) {
        let params = parent.normalizeParams(
            params: [
                "offset": String(offset),
                "num_res": String(limit)
            ],
            method: APIMethod.getTopTags
        )

        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
    }

}
