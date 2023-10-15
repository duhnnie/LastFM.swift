import Foundation

public struct TagModule {

    internal enum APIMethod: String, MethodKey {
        case getTopTracks = "gettoptracks"

        func getName() -> String {
            return "tag.\(self.rawValue)"
        }
    }

    private let instance: SwiftFM
    private let requester: Requester

    internal init(instance: SwiftFM, requester: Requester = RequestUtils.shared) {
        self.instance = instance
        self.requester = requester
    }

    public func getTopTracks(
        params: TagTopTracksParams,
        onCompletion: @escaping SwiftFM.OnCompletion<CollectionPage<TagTopTrack>>
    ) {
        let parsedParams = instance.parseParams(params: params, method: APIMethod.getTopTracks)
        let requestURL = requester.build(params: parsedParams, secure: false)

        requester.getDataAndParse(url: requestURL, headers: nil, onCompletion: onCompletion)
    }
}
