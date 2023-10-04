import Foundation

public struct User {
    public enum APIMethod: String {
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

    internal init(instance: SwiftFM) {
        self.instance = instance
    }

    private func getBaseRecentTracks<T: Decodable>(
        params: RecentTracksParams,
        extended: Bool,
        onCompletion: @escaping(Result<CollectionPage<T>, Error>) -> Void
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

        let requestURL = RequestUtils.build(params: parsedParams, secure: false)

        RequestUtils.makeGetRequest(url: requestURL, headers: nil) { result in
            switch (result) {
            case .failure(let serviceError):
                onCompletion(.failure(serviceError))
            case .success(let data):
                do {
                    let recentTracks = try JSONDecoder().decode(CollectionPage<T>.self, from: data)
                    onCompletion(.success(recentTracks))
                } catch {
                    onCompletion(.failure(error))
                }
            }
        }
    }

    public func getRecentTracks(
        params: RecentTracksParams,
        onCompletion: @escaping(Result<CollectionPage<RecentTrack>, Error>) -> Void
    ) {
        getBaseRecentTracks(params: params, extended: false, onCompletion: onCompletion)
    }

    public func getExtendedRecentTracks(
        params: RecentTracksParams,
        onCompletion: @escaping(Result<CollectionPage<ExtendedRecentTrack>, Error>) -> Void
    ) {
        getBaseRecentTracks(params: params, extended: true, onCompletion: onCompletion)
    }
}
