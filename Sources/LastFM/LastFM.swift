final public class LastFM {

    public typealias OnCompletion<T> = (Result<T, LastFMError>) -> Void

    internal static let SECURE_API_HOST = "https://ws.audioscrobbler.com/2.0"
    internal static let INSECURE_API_HOST = "http://ws.audioscrobbler.com/2.0"

    private let apiKey: String
    private let apiSecret: String
    private let secure: Bool

    lazy private(set) public var User = UserModule(parent: self, secure: self.secure)
    lazy private(set) public var Artist = ArtistModule(parent: self, secure: self.secure)
    lazy private(set) public var Track = TrackModule(parent: self, secure: self.secure)
    lazy private(set) public var Album = AlbumModule(parent: self, secure: self.secure)
    lazy private(set) public var Tag = TagModule(parent: self, secure: self.secure)
    lazy private(set) public var Geo = GeoModule(parent: self, secure: self.secure)
    lazy private(set) public var Chart = ChartModule(parent: self, secure: self.secure)
    lazy private(set) public var Library = LibraryModule(parent: self, secure: self.secure)
    lazy private(set) public var Auth = AuthModule(parent: self)

    public init(apiKey: String, apiSecret: String, secure: Bool = true) {
        self.apiKey = apiKey
        self.apiSecret = apiSecret
        self.secure = secure
    }

    internal func normalizeParams(
        params: [String: String],
        method: MethodKey,
        sessionKey: String? = nil
    ) -> [String: String] {
        var params = params

        params["api_key"] = apiKey
        params["method"] = method.getName()

        if let sessionKey = sessionKey {
            params["sk"] = sessionKey
        }

        return params
    }

    internal func normalizeParams(
        params: Params,
        method: MethodKey,
        sessionKey: String? = nil
    ) -> [String: String] {
        return normalizeParams(
            params: params.toDictionary(),
            method: method,
            sessionKey: sessionKey
        )
    }

    private func generateSignature(for data: [String: String ]) throws -> String {
        let sortedParams = data.sorted { dictA, dictB in
            return dictA.key < dictB.key
        }

        let reducedParams = sortedParams.reduce("") { partialResult, dictItem in
            return "\(partialResult)\(dictItem.key)\(dictItem.value)"
        }

        let stringToEncode = "\(reducedParams)\(self.apiSecret)"

        guard let dataToEncode = stringToEncode.data(using: .utf8) else {
            throw RuntimeError("Can't encode for signature")
        }

        return Crypto.md5Hash(data: dataToEncode)
    }

    internal func addSignature(params: inout [String: String]) throws {
        params["api_sig"] = try generateSignature(for: params)
    }
}
