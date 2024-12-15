import Foundation

public struct TagModule {

    internal enum APIMethod: String, MethodKey {
        case getTopTracks = "gettoptracks"
        case getTopArtists = "gettopartists"
        case getTopAlbums = "gettopalbums"
        case getInfo = "getinfo"
        case getWeeklyChartList = "getweeklychartlist"
        case getSimilar = "getsimilar"
        case getTopTags = "gettoptags"

        func getName() -> String {
            return "tag.\(self.rawValue)"
        }
    }

    private let parent: LastFM
    private let requester: Requester
    private let secure: Bool

    internal init(parent: LastFM, secure: Bool, requester: Requester = RequestUtils.shared) {
        self.parent = parent
        self.requester = requester
        self.secure = secure
    }

    public func getTopTracks(
        params: SearchParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<TagTopTrack>>
    ) {
        let params = parent.normalizeParams(
            params: params.toDictionary(termKey: "tag"),
            method: APIMethod.getTopTracks
        )

        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
    }

    public func getTopArtists(
        params: SearchParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<TagTopArtist>>
    ) {
        let params = parent.normalizeParams(
            params: params.toDictionary(termKey: "tag"),
            method: APIMethod.getTopArtists
        )

        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
    }


    public func getTopAlbums(
        params: SearchParams,
        onCompletion: @escaping LastFM.OnCompletion<CollectionPage<TagTopAlbum>>
    ) {
        let params = parent.normalizeParams(
            params: params.toDictionary(termKey: "tag"),
            method: APIMethod.getTopAlbums
        )

        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
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

        let normalizedParams = parent.normalizeParams(params: params, method: APIMethod.getInfo)

        requester.getDataAndParse(
            params: normalizedParams,
            secure: self.secure,
            onCompletion: onCompletion
        )
    }

    public func getWeeklyChartList(
        tag: String,
        onCompletion: @escaping LastFM.OnCompletion<CollectionList<ChartDateRange>>
    ) {
        let params = parent.normalizeParams(
            params: ["tag": tag],
            method: APIMethod.getWeeklyChartList
        )

        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
    }

    public func getSimilar(
        tag: String,
        onCompletion: @escaping LastFM.OnCompletion<CollectionList<SimilarTag>>
    ) {
        let params = parent.normalizeParams(
            params: ["tag": tag],
            method: APIMethod.getSimilar
        )

        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
    }

    public func getTopTags(
        offset: UInt = 0,
        limit: UInt = 10,
        onCompletion: @escaping LastFM.OnCompletion<CollectionList<TopGlobalTag>>
    ) {
        let params = parent.normalizeParams(
            params: [
                "offset": String(offset),
                "num_res": String(limit)
            ],
            method: APIMethod.getTopTags
        )

        requester.getDataAndParse(params: params, secure: self.secure, onCompletion: onCompletion)
    }

}
