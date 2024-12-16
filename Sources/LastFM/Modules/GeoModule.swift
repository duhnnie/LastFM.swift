import Foundation

public struct GeoModule {

    internal enum APIMethod: String, MethodKey {
        case getTopTracks = "gettoptracks"
        case getTopArtists = "gettopartists"

        func getName() -> String {
            return "geo.\(self.rawValue)"
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
        params: GeoTopTracksParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<GeoTopTrack>>
    ) {
        let params = parent.normalizeParams(params: params, method: APIMethod.getTopTracks)

        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
    }

    public func getTopArtists(
        params: SearchParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<GeoTopArtist>>
    ) {
        let params = parent.normalizeParams(
            params: params.toDictionary(termKey: "country"),
            method: APIMethod.getTopArtists
        )

        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
    }
    
}
