import Foundation

public struct TrackSimilarParams: Params {

    public var track: String
    public var artist: String
    public var autocorrect: Bool
    public var limit: UInt

    public init(track: String, artist: String, autocorrect: Bool = true, limit: UInt = 10) {
        self.track = track
        self.artist = artist
        self.autocorrect = autocorrect
        self.limit = limit
    }

    internal func toDictionary() -> Dictionary<String, String> {
        return [
            "track": track,
            "artist": artist,
            "autocorrect": autocorrect ? "1" : "0",
            "limit": String(limit)
        ]
    }

}
