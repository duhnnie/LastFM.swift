import Foundation

public struct GeoModule {

    internal enum APIMethod: String, MethodKey {
        case getTopTracks = "gettoptracks"
        case getTopArtists = "gettopartists"

        func getName() -> String {
            return "geo.\(self.rawValue)"
        }
    }

    private let instance: LastFM
    private let requester: Requester

    internal init(instance: LastFM, requester: Requester = RequestUtils.shared) {
        self.instance = instance
        self.requester = requester
    }

    public func getTopTracks(
        params: GeoTopTracksParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<GeoTopTrack>>
    ) {
        let params = instance.normalizeParams(params: params, method: APIMethod.getTopTracks)

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

    public func getTopArtists(
        params: GeoTopArtistsParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<GeoTopArtist>>
    ) {
        let params = instance.normalizeParams(params: params, method: APIMethod.getTopArtists)

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }
    
}
