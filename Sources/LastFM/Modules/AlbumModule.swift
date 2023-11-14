import Foundation

public struct AlbumModule {

    internal enum APIMethod: String, MethodKey {
        case getInfo = "getinfo"
        case search
        case addTags = "addtags"

        func getName() -> String {
            return "album.\(self.rawValue)"
        }
    }

    private let parent: LastFM
    private let requester: Requester

    internal init(parent: LastFM, requester: Requester = RequestUtils.shared) {
        self.parent = parent
        self.requester = requester
    }

    public func getInfo(
        params: AlbumInfoParams,
        onCompletion: @escaping LastFM.OnCompletion<AlbumInfo>
    ) {
        let params = parent.normalizeParams(params: params, method: APIMethod.getInfo)

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

    public func getInfo(
        params: AlbumInfoByMBIDParams,
        onCompletion: @escaping LastFM.OnCompletion<AlbumInfo>
    ) {
        let params = parent.normalizeParams(params: params, method: APIMethod.getInfo)

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

    public func search(
        params: SearchParams,
        onCompletion: @escaping LastFM.OnCompletion<SearchResults<AlbumSearchResult>>
    ) {
        let params = parent.normalizeParams(
            params: params.toDictionary(termKey: "album"),
            method: APIMethod.search
        )

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

    public func addTags(
        params: AlbumTagsParams,
        sessionKey: String,
        onCompletion: @escaping (LastFMError?) -> Void
    ) throws {
        var params = parent.normalizeParams(
            params: params,
            sessionKey: sessionKey,
            method: APIMethod.addTags
        )

        try parent.addSignature(params: &params)

        try requester.postFormURLEncoded(payload: params, secure: false, onCompletion: onCompletion)
    }
    
}
