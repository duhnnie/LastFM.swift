import Foundation

public struct AlbumModule {

    internal enum APIMethod: String, MethodKey {
        case getInfo = "getinfo"
        case search

        func getName() -> String {
            return "album.\(self.rawValue)"
        }
    }

    private let instance: LastFM
    private let requester: Requester

    internal init(instance: LastFM, requester: Requester = RequestUtils.shared) {
        self.instance = instance
        self.requester = requester
    }

    public func getInfo(
        params: AlbumInfoParams,
        onCompletion: @escaping LastFM.OnCompletion<AlbumInfo>
    ) {
        let params = instance.normalizeParams(params: params, method: APIMethod.getInfo)

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

    public func getInfo(
        params: AlbumInfoByMBIDParams,
        onCompletion: @escaping LastFM.OnCompletion<AlbumInfo>
    ) {
        let params = instance.normalizeParams(params: params, method: APIMethod.getInfo)

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

    public func search(
        params: SearchParams,
        onCompletion: @escaping LastFM.OnCompletion<SearchResults<AlbumSearchResult>>
    ) {
        let params = instance.normalizeParams(
            params: params.toDictionary(termKey: "album"),
            method: APIMethod.search
        )

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }
    
}
