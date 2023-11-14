import Foundation

public struct TrackParams: Params {

    public var track: String
    public var artist: String

    public init(track: String, artist: String) {
        self.track = track
        self.artist = artist
    }

    internal func toDictionary() -> Dictionary<String, String> {
        return [
            "track": track,
            "artist": artist
        ]
    }
}
