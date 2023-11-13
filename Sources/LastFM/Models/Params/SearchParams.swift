import Foundation

public struct SearchParams {

    public var term: String
    public var page: UInt
    public var limit: UInt

    public init(term: String, limit: UInt = 50, page: UInt = 1) {
        self.term = term
        self.limit = limit
        self.page = page
    }

    internal func toDictionary(termKey: String = "term") -> Dictionary<String, String> {
        return [
            termKey: self.term,
            "limit": String(self.limit),
            "page": String(self.page)
        ]
    }

}
