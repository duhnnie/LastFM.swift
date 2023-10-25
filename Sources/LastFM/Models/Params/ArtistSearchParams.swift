import Foundation

public struct ArtistSearchParams: Params {

    public var artist: String
    public var limit: UInt
    public var page: UInt

    public init(
        artist: String,
        limit: UInt = 50,
        page: UInt = 1
    ) {
        self.artist = artist
        self.limit = limit
        self.page = page
    }

    internal func toDictionary() -> Dictionary<String, String> {
        return [
            "artist": artist,
            "limit": String(limit),
            "page": String(page)
        ]
    }
    
}
