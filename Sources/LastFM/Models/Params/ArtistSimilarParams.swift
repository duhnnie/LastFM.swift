import Foundation

public struct ArtistSimilarParams: Params {

    public var artist: String
    public var mbid: String?
    public var autocorrect: Bool
    public var limit: UInt

    public init(
        artist: String = "",
        mbid: String? = nil,
        autocorrect: Bool = true,
        limit: UInt = 50
    ) {
        self.artist = artist
        self.mbid = mbid
        self.autocorrect = autocorrect
        self.limit = limit
    }

    internal func toDictionary() -> Dictionary<String, String> {
        var dict = [
            "autocorrect": autocorrect ? "1" : "0",
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
