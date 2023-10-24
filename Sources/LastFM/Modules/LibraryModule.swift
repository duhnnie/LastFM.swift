import Foundation

public struct LibraryModule {

    internal enum APIMethod: String, MethodKey {
        case getArtists = "getartists"

        func getName() -> String {
            return "library.\(self.rawValue)"
        }
    }

    private let instance: LastFM
    private let requester: Requester

    internal init(instance: LastFM, requester: Requester = RequestUtils.shared) {
        self.instance = instance
        self.requester = requester
    }

    public func getArtists(
        params: LibraryArtistsParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<LibraryArtist>>
    ) {
        let params = instance.normalizeParams(params: params, method: APIMethod.getArtists)

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

}
