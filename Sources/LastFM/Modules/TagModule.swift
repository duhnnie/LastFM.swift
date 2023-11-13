import Foundation

public struct TagModule {

    internal enum APIMethod: String, MethodKey {
        case getTopTracks = "gettoptracks"
        case getTopArtists = "gettopartists"
        case getTopAlbums = "gettopalbums"
        case getInfo = "getinfo"

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
        params: SearchParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<TagTopTrack>>
    ) {
        let params = instance.normalizeParams(
            params: params.toDictionary(termKey: "tag"),
            method: APIMethod.getTopTracks
        )

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

    public func getTopArtists(
        params: SearchParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<TagTopArtist>>
    ) {
        let params = instance.normalizeParams(
            params: params.toDictionary(termKey: "tag"),
            method: APIMethod.getTopArtists
        )

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }


    public func getTopAlbums(
        params: SearchParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<TagTopAlbum>>
    ) {
        let params = instance.normalizeParams(
            params: params.toDictionary(termKey: "tag"),
            method: APIMethod.getTopAlbums
        )

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }

    public func getInfo(
        name: String,
        lang: String? = nil,
        onCompletion: @escaping LastFM.OnCompletion<TagInfo>
    ) {
        var params = ["name": name]

        if let lang = lang {
            params["lang"] = lang
        }

        let normalizedParams = instance.normalizeParams(params: params, method: APIMethod.getInfo)

        requester.getDataAndParse(
            params: normalizedParams,
            secure: false,
            onCompletion: onCompletion
        )
    }
    
}
