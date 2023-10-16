import Foundation

public struct ArtistTopTracksParams: Params {

    public var artist: String
    public var mbid: String?
    public var autocorrect: Bool
    public var page: UInt
    public var limit: UInt

    public init(
        artist: String = "",
        mbid: String? = nil,
        autocorrect: Bool = true,
        page: UInt = 1,
        limit: UInt = 50
    ) {
        self.artist = artist
        self.mbid = mbid
        self.autocorrect = autocorrect
        self.page = page
        self.limit = limit
    }

    internal func toDictionary() -> Dictionary<String, String> {
        var dict = [
            "autocorrect": autocorrect ? "1" : "0",
            "page": String(page),
            "limit": String(limit)
        ]

        if let mbid = mbid {
            dict["mbid"] = mbid
        } else {
            dict["artist"] = artist
        }

        return dict
    }
    
}
