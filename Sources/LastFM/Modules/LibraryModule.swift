import Foundation

public struct LibraryModule {

    internal enum APIMethod: String, MethodKey {
        case getArtists = "getartists"

        func getName() -> String {
            return "library.\(self.rawValue)"
        }
    }

    private let parent: LastFM
    private let requester: Requester

    internal init(parent: LastFM, requester: Requester = RequestUtils.shared) {
        self.parent = parent
        self.requester = requester
    }

    public func getArtists(
        params: SearchParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<LibraryArtist>>
    ) {
        let params = parent.normalizeParams(
            params: params.toDictionary(termKey: "user"),
            method: APIMethod.getArtists
        )

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

}
