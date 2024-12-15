import Foundation

public struct ChartModule {

    internal enum APIMethod: String, MethodKey {
        case getTopTracks = "gettoptracks"
        case getTopArtists = "gettopartists"
        case getTopTags = "gettoptags"

        func getName() -> String {
            return "chart.\(self.rawValue)"
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

    public func getTopTracks(
        params: ChartTopItemsParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<ChartTopTrack>>
    ) {
        let params = parent.normalizeParams(params: params, method: APIMethod.getTopTracks)

        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
    }

    public func getTopArtists(
        params: ChartTopItemsParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<ChartTopArtist>>
    ) {
        let params = parent.normalizeParams(params: params, method: APIMethod.getTopArtists)

        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
    }

    public func getTopTags(
        page: UInt,
        limit: UInt,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<ChartTopTag>>
    ) {
        let params = parent.normalizeParams(
            params: [
                "page": String(page),
                "limit": String(limit)
            ], method: APIMethod.getTopTags
        )

        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
    }

}
