import Foundation

public struct UserModule {
    internal enum APIMethod: String, MethodKey {
        case getFriends = "getfriends"
        case getInfo
        case getLovedTracks
        case getPersonalTags
        case getRecentTracks
        case getTopAlbums
        case getTopArtists
        case getTopTags
        case getTopTracks
        case getWeeklyAlbumChart
        case getWeeklyArtistChart
        case getWeeklyChartList
        case getWeeklyTrackChart

        func getName() -> String {
            return "user.\(self.rawValue.lowercased())"
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
    private func getBaseRecentTracks<T: Decodable>(
        params: RecentTracksParams,
        extended: Bool
    ) async throws -> CollectionPage<T> {
        var params = parent.normalizeParams(params: params, method: APIMethod.getRecentTracks)

        params["extended"] = extended ? "1" : "0"

        return try await requester.getDataAndParse(params: params, type: CollectionPage<T>.self, secure: self.secure)
    }

    private func getBaseRecentTracks<T: Decodable>(
        params: RecentTracksParams,
        extended: Bool,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<T>>
    ) {
        var params = parent.normalizeParams(params: params, method: APIMethod.getRecentTracks)

        params["extended"] = extended ? "1" : "0"

        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getRecentTracks(
        params: RecentTracksParams
    ) async throws -> CollectionPage<RecentTrack> {
        return try await getBaseRecentTracks(params: params, extended: false)
    }

    public func getRecentTracks(
        params: RecentTracksParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<RecentTrack>>
    ) {
        getBaseRecentTracks(params: params, extended: false, onCompletion: onCompletion)
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getExtendedRecentTracks(
        params: RecentTracksParams
    ) async throws -> CollectionPage<ExtendedRecentTrack> {
        return try await getBaseRecentTracks(params: params, extended: true)
    }

    public func getExtendedRecentTracks(
        params: RecentTracksParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<ExtendedRecentTrack>>
    ) {
        getBaseRecentTracks(params: params, extended: true, onCompletion: onCompletion)
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getTopTracks(
        params: UserTopItemsParams
    ) async throws -> CollectionPage<UserTopTrack> {
        let params = parent.normalizeParams(params: params, method: APIMethod.getTopTracks)

        return try await requester.getDataAndParse(params: params, type: CollectionPage<UserTopTrack>.self, secure: self.secure)
    }

    public func getTopTracks(
        params: UserTopItemsParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<UserTopTrack>>
    ) {
        let params = parent.normalizeParams(params: params, method: APIMethod.getTopTracks)

        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getWeeklyTrackChart(
        params: UserWeeklyChartParams
    ) async throws -> CollectionList<UserWeeklyTrackChart> {
        let params = parent.normalizeParams(
            params: params,
            method: APIMethod.getWeeklyTrackChart
        )

        return try await requester.getDataAndParse(
            params: params,
            type: CollectionList<UserWeeklyTrackChart>.self,
            secure: self.secure
        )
    }

    public func getWeeklyTrackChart(
        params: UserWeeklyChartParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionList<UserWeeklyTrackChart>>
    ) {
        let params = parent.normalizeParams(
            params: params,
            method: APIMethod.getWeeklyTrackChart
        )

        requester.getDataAndParse(params: params, secure: true, onCompletion: onCompletion)
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getLovedTracks(params: SearchParams) async throws -> CollectionPage<LovedTrack> {
        let params = parent.normalizeParams(
            params: params.toDictionary(termKey: "user"),
            method: APIMethod.getLovedTracks
        )

        return try await requester.getDataAndParse(
            params: params,
            type: CollectionPage<LovedTrack>.self,
            secure: self.secure
        )
    }

    public func getLovedTracks(
        params: SearchParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<LovedTrack>>
    ) {
        let params = parent.normalizeParams(
            params: params.toDictionary(termKey: "user"),
            method: APIMethod.getLovedTracks
        )

        requester.getDataAndParse(params: params, secure: true, onCompletion: onCompletion)
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getTopArtists(
        params: UserTopItemsParams
    ) async throws -> CollectionPage<UserTopArtist> {
        let params = parent.normalizeParams(params: params, method: APIMethod.getTopArtists)

        return try await requester.getDataAndParse(
            params: params,
            type: CollectionPage<UserTopArtist>.self,
            secure: self.secure
        )
    }

    public func getTopArtists(
        params: UserTopItemsParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<UserTopArtist>>
    ) {
        let params = parent.normalizeParams(params: params, method: APIMethod.getTopArtists)

        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getWeeklyArtistChart(
        params: UserWeeklyChartParams
    ) async throws -> CollectionList<UserWeeklyArtistChart> {
        let params = parent.normalizeParams(params: params, method: APIMethod.getWeeklyArtistChart)

        return try await requester.getDataAndParse(
            params: params,
            type: CollectionList<UserWeeklyArtistChart>.self,
            secure: self.secure
        )
    }

    public func getWeeklyArtistChart(
        params: UserWeeklyChartParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionList<UserWeeklyArtistChart>>
    ) {
        let params = parent.normalizeParams(params: params, method: APIMethod.getWeeklyArtistChart)

        requester.getDataAndParse(params: params, secure: true, onCompletion: onCompletion)
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getTopAlbums(
        params: UserTopItemsParams
    ) async throws -> CollectionPage<UserTopAlbum> {
        let params = parent.normalizeParams(params: params, method: APIMethod.getTopAlbums)

        return try await requester.getDataAndParse(
            params: params,
            type: CollectionPage<UserTopAlbum>.self,
            secure: self.secure
        )
    }

    public func getTopAlbums(
        params: UserTopItemsParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<UserTopAlbum>>
    ) {
        let params = parent.normalizeParams(params: params, method: APIMethod.getTopAlbums)

        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getWeeklyAlbumChart(
        params: UserWeeklyChartParams
    ) async throws -> CollectionList<UserWeeklyAlbumChart> {
        let params = parent.normalizeParams(params: params, method: APIMethod.getWeeklyAlbumChart)

        return try await requester.getDataAndParse(
            params: params,
            type: CollectionList<UserWeeklyAlbumChart>.self,
            secure: self.secure
        )
    }

    public func getWeeklyAlbumChart(
        params: UserWeeklyChartParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionList<UserWeeklyAlbumChart>>
    ) {
        let params = parent.normalizeParams(params: params, method: APIMethod.getWeeklyAlbumChart)

        requester.getDataAndParse(params: params, secure: true, onCompletion: onCompletion)
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getInfo(user: String) async throws -> UserInfo {
        let params = parent.normalizeParams(params: ["user": user], method: APIMethod.getInfo)

        return try await requester.getDataAndParse(
            params: params,
            type: UserInfo.self,
            secure: self.secure
        )
    }

    public func getInfo(user: String, onCompletion: @escaping LastFM.OnCompletion<UserInfo>) {
        let params = parent.normalizeParams(params: ["user": user], method: APIMethod.getInfo)

        requester.getDataAndParse(params: params, secure: true, onCompletion: onCompletion)
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getInfo(sessionKey: String) async throws -> UserInfo {
        let params = parent.normalizeParams(params: [:], method: APIMethod.getInfo, sessionKey: sessionKey)

        return try await requester.postFormURLEncodedAndParse(
            payload: params,
            type: UserInfo.self,
            secure: self.secure
        )
    }
    
    public func getInfo(sessionKey: String, onCompletion: @escaping LastFM.OnCompletion<UserInfo>) throws {
        let params = parent.normalizeParams(params: [:], method: APIMethod.getInfo, sessionKey: sessionKey)

        try requester.postFormURLEncodedAndParse(payload: params, secure: true, onCompletion: onCompletion)
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getFriends(params: SearchParams) async throws -> CollectionPage<UserPublicInfo> {
        let params = parent.normalizeParams(
            params: params.toDictionary(termKey: "user"),
            method: APIMethod.getFriends
        )

        return try await requester.getDataAndParse(
            params: params,
            type: CollectionPage<UserPublicInfo>.self,
            secure: self.secure
        )
    }

    public func getFriends(
        params: SearchParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<UserPublicInfo>>
    ) {
        let params = parent.normalizeParams(
            params: params.toDictionary(termKey: "user"),
            method: APIMethod.getFriends
        )

        requester.getDataAndParse(params: params, secure: true, onCompletion: onCompletion)
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getWeeklyChartList(user: String) async throws -> CollectionList<ChartDateRange> {
        let params = parent.normalizeParams(
            params: ["user": user],
            method: APIMethod.getWeeklyChartList
        )

        return try await requester.getDataAndParse(
            params: params,
            type: CollectionList<ChartDateRange>.self,
            secure: self.secure
        )
    }

    public func getWeeklyChartList(
        user: String,
        onCompletion: @escaping LastFM.OnCompletion<CollectionList<ChartDateRange>>
    ) {
        let params = parent.normalizeParams(
            params: ["user": user],
            method: APIMethod.getWeeklyChartList
        )

        requester.getDataAndParse(params: params, secure: true, onCompletion: onCompletion)
    }

}
