import Foundation

public struct ArtistModule {

    internal enum APIMethod: String, MethodKey {
        case getTopTracks = "gettoptracks"
        case getSimilar = "getsimilar"
        case search = "search"

        func getName() -> String {
            return "artist.\(self.rawValue)"
        }
    }

    private let instance: LastFM
    private let requester: Requester

    internal init(instance: LastFM, requester: Requester = RequestUtils.shared) {
        self.instance = instance
        self.requester = requester
    }

    public func getTopTracks(
        params: ArtistTopTracksParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<ArtistTopTrack>>
    ) {
        let params = instance.normalizeParams(params: params, method: APIMethod.getTopTracks)

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

    public func getSimilar(
        params: ArtistSimilarParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionList<ArtistSimilar>>
    ) {
        let params = instance.normalizeParams(params: params, method: APIMethod.getSimilar)

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

    public func search(
        params: ArtistSearchParams,
        onCompletion: @escaping LastFM.OnCompletion<SearchResults<ArtistSearchResult>>
    ) {
        let params = instance.normalizeParams(params: params, method: APIMethod.search)

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

}
