public class SwiftFM {
    public private(set) var text = "Hello, World!"
    internal let apiKey: String
    internal let apiSecret: String

    lazy public var user: User = User(instance: self)

    public init(apiKey: String, apiSecret: String) {
        self.apiKey = apiKey
        self.apiSecret = apiSecret
    }
}
