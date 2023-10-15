import Foundation

public struct TagTopTracksParams: Params {

    public var tag: String
    public var limit: UInt
    public var page: UInt

    public init(tag: String, limit: UInt, page: UInt) {
        self.tag = tag
        self.limit = limit
        self.page = page
    }

    internal func toDictionary() -> Dictionary<String, String> {
        return [
            "tag": tag,
            "limit": String(limit),
            "page": String(page)
        ]
    }

}
