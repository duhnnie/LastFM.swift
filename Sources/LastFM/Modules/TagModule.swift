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
        let params = instance.normalizeParams(params: params, method: APIMethod.getTopTracks)

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }
}
