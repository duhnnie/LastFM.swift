import Foundation

public struct ArtistSimilarParams: Params {

    public var artist: String
    public var autocorrect: Bool
    public var limit: UInt

    public init(
        artist: String = "",
        autocorrect: Bool = true,
        limit: UInt = 50
    ) {
        self.artist = artist
        self.autocorrect = autocorrect
        self.limit = limit
    }

    internal func toDictionary() -> Dictionary<String, String> {
        return [
            "autocorrect": autocorrect ? "1" : "0",
            "limit": String(limit),
            "artist": artist
        ]
    }
    
}
