import CryptoKit

final public class LastFM {

    public typealias OnCompletion<T> = (Result<T, LastFMError>) -> Void

    internal static let SECURE_API_HOST = "https://ws.audioscrobbler.com/2.0"
    internal static let INSECURE_API_HOST = "http://ws.audioscrobbler.com/2.0"

    private let apiKey: String
    private let apiSecret: String

    lazy private(set) public var User = UserModule(parent: self)
    lazy private(set) public var Artist = ArtistModule(parent: self)
    lazy private(set) public var Track = TrackModule(parent: self)
    lazy private(set) public var Tag = TagModule(parent: self)
    lazy private(set) public var Geo = GeoModule(parent: self)
    lazy private(set) public var Chart = ChartModule(parent: self)
    lazy private(set) public var Library = LibraryModule(parent: self)
    lazy private(set) public var Auth = AuthModule(parent: self)

    public init(apiKey: String, apiSecret: String) {
        self.apiKey = apiKey
        self.apiSecret = apiSecret
    }

    internal func normalizeParams(
        params: [String: String],
        sessionKey: String? = nil,
        method: MethodKey
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
        sessionKey: String? = nil,
        method: MethodKey
    ) -> [String: String] {
        return normalizeParams(
            params: params.toDictionary(),
            sessionKey: sessionKey,
            method: method
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

        return Insecure.MD5.hash(data: dataToEncode)
            .map{String(format: "%02x", $0)}
            .joined()
    }

    internal func addSignature(params: inout [String: String]) throws {
        params["api_sig"] = try generateSignature(for: params)
    }
}
