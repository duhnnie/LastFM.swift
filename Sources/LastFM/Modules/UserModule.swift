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

    internal init(parent: LastFM, requester: Requester = RequestUtils.shared) {
        self.parent = parent
        self.requester = requester
    }

    private func getBaseRecentTracks<T: Decodable>(
        params: RecentTracksParams,
        extended: Bool,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<T>>
    ) {
        var params = parent.normalizeParams(params: params, method: APIMethod.getRecentTracks)

        params["extended"] = extended ? "1" : "0"

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

    public func getRecentTracks(
        params: RecentTracksParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<RecentTrack>>
    ) {
        getBaseRecentTracks(params: params, extended: false, onCompletion: onCompletion)
    }

    public func getExtendedRecentTracks(
        params: RecentTracksParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<ExtendedRecentTrack>>
    ) {
        getBaseRecentTracks(params: params, extended: true, onCompletion: onCompletion)
    }

    public func getTopTracks(
        params: UserTopItemsParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<UserTopTrack>>
    ) {
        let params = parent.normalizeParams(params: params, method: APIMethod.getTopTracks)

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

    public func getWeeklyTrackChart(
        params: UserWeeklyChartParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionList<UserWeeklyTrackChart>>
    ) {
        let params = parent.normalizeParams(
            params: params,
            method: APIMethod.getWeeklyTrackChart
        )

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

    public func getLovedTracks(
        params: SearchParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<LovedTrack>>
    ) {
        let params = parent.normalizeParams(
            params: params.toDictionary(termKey: "user"),
            method: APIMethod.getLovedTracks
        )

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

    public func getTopArtists(
        params: UserTopItemsParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<UserTopArtist>>
    ) {
        let params = parent.normalizeParams(params: params, method: APIMethod.getTopArtists)

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

    public func getWeeklyArtistChart(
        params: UserWeeklyChartParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionList<UserWeeklyArtistChart>>
    ) {
        let params = parent.normalizeParams(params: params, method: APIMethod.getWeeklyArtistChart)

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

    public func getTopAlbums(
        params: UserTopItemsParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<UserTopAlbum>>
    ) {
        let params = parent.normalizeParams(params: params, method: APIMethod.getTopAlbums)

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

    public func getWeeklyAlbumChart(
        params: UserWeeklyChartParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionList<UserWeeklyAlbumChart>>
    ) {
        let params = parent.normalizeParams(params: params, method: APIMethod.getWeeklyAlbumChart)

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

    public func getInfo(user: String, onCompletion: @escaping LastFM.OnCompletion<UserInfo>) {
        let params = parent.normalizeParams(params: ["user": user], method: APIMethod.getInfo)

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

    public func getFriends(
        params: SearchParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<UserPublicInfo>>
    ) {
        let params = parent.normalizeParams(
            params: params.toDictionary(termKey: "user"),
            method: APIMethod.getFriends
        )

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

    public func getWeeklyChartList(
        user: String,
        onCompletion: @escaping LastFM.OnCompletion<CollectionList<ChartDateRange>>
    ) {
        let params = parent.normalizeParams(
            params: ["user": user],
            method: APIMethod.getWeeklyChartList
        )

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

}
