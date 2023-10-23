import Foundation

public struct TagModule {

    internal enum APIMethod: String, MethodKey {
        case getTopTracks = "gettoptracks"
        case getTopArtists = "gettopartists"

        func getName() -> String {
            return "tag.\(self.rawValue)"
        }
    }

    private let instance: LastFM
    private let requester: Requester

    internal init(instance: LastFM, requester: Requester = RequestUtils.shared) {
        self.instance = instance
        self.requester = requester
    }

    public func getTopTracks(
        params: TagTopTracksParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<TagTopTrack>>
    ) {
        let params = instance.normalizeParams(params: params, method: APIMethod.getTopTracks)

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

    public func getTopArtists(
        params: TagTopArtistsParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<TagTopArtist>>
    ) {
        let params = instance.normalizeParams(params: params, method: APIMethod.getTopArtists)

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }
}
