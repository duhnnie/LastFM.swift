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
            return "user.\(self.rawValue)"
        }
    }

    private let instance: SwiftFM
    private let requester: Requester

    internal init(instance: SwiftFM, requester: Requester = RequestUtils.shared) {
        self.instance = instance
        self.requester = requester
    }

    private func getBaseRecentTracks<T: Decodable>(
        params: RecentTracksParams,
        extended: Bool,
        onCompletion: @escaping SwiftFM.OnCompletion<CollectionPage<T>>
    ) {
        var parsedParams = instance.parseParams(params: params, method: APIMethod.getRecentTracks)

        parsedParams["extended"] = extended ? "1" : "0"

        let requestURL = requester.build(params: parsedParams, secure: false)

        requester.getDataAndParse(
            url: requestURL,
            headers: nil,
            onCompletion: onCompletion
        )
    }

    public func getRecentTracks(
        params: RecentTracksParams,
        onCompletion: @escaping SwiftFM.OnCompletion<CollectionPage<RecentTrack>>
    ) {
        getBaseRecentTracks(params: params, extended: false, onCompletion: onCompletion)
    }

    public func getExtendedRecentTracks(
        params: RecentTracksParams,
        onCompletion: @escaping SwiftFM.OnCompletion<CollectionPage<ExtendedRecentTrack>>
    ) {
        getBaseRecentTracks(params: params, extended: true, onCompletion: onCompletion)
    }

    public func getTopTracks(
        params: UserTopTracksParams,
        onCompletion: @escaping SwiftFM.OnCompletion<CollectionPage<UserTopTrack>>
    ) {
        let parsedParams = instance.parseParams(params: params, method: APIMethod.getTopTracks)
        let requestURL = requester.build(params: parsedParams, secure: false)

        requester.getDataAndParse(
            url: requestURL,
            headers: nil,
            onCompletion: onCompletion
        )
    }

    public func getWeeklyTrackChart(
        params: UserWeeklyTrackChartParams,
        onCompletion: @escaping SwiftFM.OnCompletion<CollectionList<UserWeeklyChartTrack>>
    ) {
        let parsedParams = instance.parseParams(
            params: params,
            method: APIMethod.getWeeklyTrackChart
        )

        let requestURL = requester.build(params: parsedParams, secure: false)

        requester.getDataAndParse(
            url: requestURL,
            headers: nil,
            onCompletion: onCompletion
        )
    }

    public func getLovedTracks(
        params: LovedTracksParams,
        onCompletion: @escaping SwiftFM.OnCompletion<CollectionPage<LovedTrack>>
    ) {
        let parsedParams = instance.parseParams(params: params, method: APIMethod.getLovedTracks)
        let requestURL = requester.build(params: parsedParams, secure: false)

        requester.getDataAndParse(
            url: requestURL,
            headers: nil,
            onCompletion: onCompletion
        )
    }
}
