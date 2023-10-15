import Foundation

public struct GeoModule {

    internal enum APIMethod: String, MethodKey {
        case getTopTracks = "gettoptracks"

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
        let parsedParams = instance.parseParams(params: params, method: APIMethod.getTopTracks)
        let requestURL = requester.build(params: parsedParams, secure: false)

        requester.getDataAndParse(url: requestURL, headers: nil, onCompletion: onCompletion)
    }
    
}
