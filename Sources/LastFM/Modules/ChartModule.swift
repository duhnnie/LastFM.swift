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

    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getTopTracks(params: ChartTopItemsParams) async throws -> CollectionPage<ChartTopTrack> {
        let params = parent.normalizeParams(params: params, method: APIMethod.getTopTracks)

        return try await requester.getDataAndParse(params: params, type: CollectionPage<ChartTopTrack>.self, secure: self.secure)
    }

    public func getTopTracks(
        params: ChartTopItemsParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<ChartTopTrack>>
    ) {
        let params = parent.normalizeParams(params: params, method: APIMethod.getTopTracks)

        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getTopArtists(params: ChartTopItemsParams) async throws -> CollectionPage<ChartTopArtist> {
        let params = parent.normalizeParams(params: params, method: APIMethod.getTopArtists)

        return try await requester.getDataAndParse(params: params, type: CollectionPage<ChartTopArtist>.self, secure: self.secure)
    }

    public func getTopArtists(
        params: ChartTopItemsParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<ChartTopArtist>>
    ) {
        let params = parent.normalizeParams(params: params, method: APIMethod.getTopArtists)

        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getTopTags(page: UInt, limit: UInt) async throws -> CollectionPage<ChartTopTag> {
        let params = parent.normalizeParams(
            params: [
                "page": String(page),
                "limit": String(limit)
            ], method: APIMethod.getTopTags
        )

        return try await requester.getDataAndParse(params: params, type: CollectionPage<ChartTopTag>.self, secure: self.secure)
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
