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

    private let instance: LastFM
    private let requester: Requester

    internal init(instance: LastFM, requester: Requester = RequestUtils.shared) {
        self.instance = instance
        self.requester = requester
    }

    private func getBaseRecentTracks<T: Decodable>(
        params: RecentTracksParams,
        extended: Bool,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<T>>
    ) {
        var params = instance.normalizeParams(params: params, method: APIMethod.getRecentTracks)

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
        params: UserTopTracksParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<UserTopTrack>>
    ) {
        let params = instance.normalizeParams(params: params, method: APIMethod.getTopTracks)

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

    public func getWeeklyTrackChart(
        params: UserWeeklyChartParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionList<UserWeeklyTrackChart>>
    ) {
        let params = instance.normalizeParams(
            params: params,
            method: APIMethod.getWeeklyTrackChart
        )

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

    public func getLovedTracks(
        params: LovedTracksParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<LovedTrack>>
    ) {
        let params = instance.normalizeParams(params: params, method: APIMethod.getLovedTracks)

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

    public func getTopArtists(
        params: UserTopArtistsParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<UserTopArtist>>
    ) {
        let params = instance.normalizeParams(params: params, method: APIMethod.getTopArtists)

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

    public func getWeeklyArtistChart(
        params: UserWeeklyChartParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionList<UserWeeklyArtistChart>>
    ) {
        let params = instance.normalizeParams(params: params, method: APIMethod.getWeeklyArtistChart)

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

    public func getTopAlbums(
        params: UserTopAlbumsParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<UserTopAlbum>>
    ) {
        let params = instance.normalizeParams(params: params, method: APIMethod.getTopAlbums)

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

    public func getWeeklyAlbumChart(
        params: UserWeeklyChartParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionList<UserWeeklyAlbumChart>>
    ) {
        let params = instance.normalizeParams(params: params, method: APIMethod.getWeeklyAlbumChart)

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

}
