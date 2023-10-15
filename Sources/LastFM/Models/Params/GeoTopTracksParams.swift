import Foundation

public struct GeoTopTracksParams: Params {

    public var country: String
    public var location: String?
    public var limit: UInt
    public var page: UInt

    public init(country: String, location: String? = nil, limit: UInt = 50, page: UInt = 1) {
        self.country = country
        self.location = location
        self.limit = limit
        self.page = page
    }

    internal func toDictionary() -> Dictionary<String, String> {
        var dict = [
            "country": country,
            "limit": String(limit),
            "page": String(page)
        ]

        if let location = location {
            dict["location"] = location
        }

        return dict
    }

}
