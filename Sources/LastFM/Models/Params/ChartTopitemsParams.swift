import Foundation

public struct ChartTopItemsParams: Params {

    public var page: UInt
    public var limit: UInt

    public init(page: UInt = 1, limit: UInt = 50) {
        self.page = page
        self.limit = limit
    }

    func toDictionary() -> Dictionary<String, String> {
        return [
            "page": String(page),
            "limit": String(limit)
        ]
    }
    
}
