final public class SwiftFM {

    public typealias OnCompletion<T> = (Result<T, Error>) -> Void

    public private(set) var text = "Hello, World!"

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
