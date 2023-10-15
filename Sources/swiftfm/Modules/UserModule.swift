import Foundation

public struct UserModule {
    internal enum APIMethod: String {
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

        func getMethodName() -> String {
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
        var parsedParams = [
            ("method", APIMethod.getRecentTracks.getMethodName()),
            ("user", params.user),
            ("limit", String(params.limit)),
            ("page", String(params.page)),
            ("extended", extended ? "1" : "0"),
            ("api_key", instance.apiKey),
            ("format", "json"),
        ];

        if let from = params.from {
            parsedParams.append(("from", String(from)))
        }

        if let to = params.to {
            parsedParams.append(("to", String(to)))
        }

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
        let parsedParams = [
            ("method", APIMethod.getTopTracks.getMethodName()),
            ("user", params.user),
            ("limit", String(params.limit)),
            ("page", String(params.page)),
            ("period", params.period.rawValue),
            ("api_key", instance.apiKey),
            ("format", "json"),
        ];

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
        let parsedParams = [
            ("method", APIMethod.getWeeklyTrackChart.getMethodName()),
            ("user", params.user),
            ("from", String(params.from)),
            ("to", String(params.to)),
            ("api_key", instance.apiKey),
            ("format", "json")
        ]

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
        let parsedParams = [
            ("method", APIMethod.getLovedTracks.getMethodName()),
            ("user", params.user),
            ("limit", String(params.limit)),
            ("page", String(params.page)),
            ("api_key", instance.apiKey),
            ("format", "json")
        ]

        let requestURL = requester.build(params: parsedParams, secure: false)

        requester.getDataAndParse(
            url: requestURL,
            headers: nil,
            onCompletion: onCompletion
        )
    }
}
