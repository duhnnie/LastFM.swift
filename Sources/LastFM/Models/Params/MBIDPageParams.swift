import Foundation

public struct MBIDPageParams: Params {

    public var mbid: String
    public var autocorrect: Bool
    public var page: UInt
    public var limit: UInt

    public init(
        mbid: String,
        autocorrect: Bool = true,
        page: UInt = 1,
        limit: UInt = 50
    ) {
        self.mbid = mbid
        self.autocorrect = autocorrect
        self.page = page
        self.limit = limit
    }

    internal func toDictionary() -> Dictionary<String, String> {
        return [
            "mbid": mbid,
            "autocorrect": autocorrect ? "1" : "0",
            "page": String(page),
            "limit": String(limit)
        ]
    }

}
