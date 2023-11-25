import Foundation

public struct ArtistTopItemsParams: Params {

    public var artist: String
    public var autocorrect: Bool
    public var page: UInt
    public var limit: UInt

    public init(
        artist: String,
        autocorrect: Bool = true,
        page: UInt = 1,
        limit: UInt = 50
    ) {
        self.artist = artist
        self.autocorrect = autocorrect
        self.page = page
        self.limit = limit
    }

    internal func toDictionary() -> Dictionary<String, String> {
        return [
            "artist": artist,
            "autocorrect": autocorrect ? "1" : "0",
            "page": String(page),
            "limit": String(limit)
        ]
    }
    
}
