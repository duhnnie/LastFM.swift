import Foundation

public struct ChartModule {

    internal enum APIMethod: String, MethodKey {
        case getTopTracks = "gettoptracks"

        func getName() -> String {
            return "chart.\(self.rawValue)"
        }
    }

    private let instance: LastFM
    private let requester: Requester

    internal init(instance: LastFM, requester: Requester = RequestUtils.shared) {
        self.instance = instance
        self.requester = requester
    }

    public func getTopTracks(
        params: ChartTopTracksParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<ChartTopTrack>>
    ) {
        let params = instance.normalizeParams(params: params, method: APIMethod.getTopTracks)

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

}
