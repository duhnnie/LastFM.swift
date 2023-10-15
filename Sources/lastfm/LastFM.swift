final public class LastFM {

    public typealias OnCompletion<T> = (Result<T, LastFMError>) -> Void

    internal static let SECURE_API_HOST = "https://ws.audioscrobbler.com/2.0"
    internal static let INSECURE_API_HOST = "http://ws.audioscrobbler.com/2.0"

    private let apiKey: String
    private let apiSecret: String

    lazy public var User = UserModule(instance: self)
    lazy public var Tag = TagModule(instance: self)

    public init(apiKey: String, apiSecret: String) {
        self.apiKey = apiKey
        self.apiSecret = apiSecret
    }

    internal func parseParams(params: Params, method: MethodKey) -> [String: String] {
        var params = params.toDictionary()

        params["method"] = method.getName()
        params["api_key"] = apiKey
        params["format"] = "json"

        return params
    }
}
