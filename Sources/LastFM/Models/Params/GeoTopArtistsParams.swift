import Foundation

public struct GeoTopArtistsParams: Params {

    public var country: String
    public var limit: UInt
    public var page: UInt

    public init(country: String, limit: UInt = 50, page: UInt = 1) {
        self.country = country
        self.limit = limit
        self.page = page
    }

    internal func toDictionary() -> Dictionary<String, String> {
        return [
            "country": country,
            "limit": String(limit),
            "page": String(page)
        ]
    }

}
