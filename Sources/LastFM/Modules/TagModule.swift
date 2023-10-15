import Foundation

public struct TagModule {

    internal enum APIMethod: String, MethodKey {
        case getTopTracks = "gettoptracks"

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
        let parsedParams = instance.parseParams(params: params, method: APIMethod.getTopTracks)
        let requestURL = requester.build(params: parsedParams, secure: false)

        requester.getDataAndParse(url: requestURL, headers: nil, onCompletion: onCompletion)
    }
}
