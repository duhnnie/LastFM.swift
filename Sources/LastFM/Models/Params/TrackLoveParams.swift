import Foundation

public struct TrackLoveParams: Params {

    public var track: String
    public var artist: String
    public var sessionKey: String

    public init(track: String, artist: String, sessionKey: String) {
        self.track = track
        self.artist = artist
        self.sessionKey = sessionKey
    }

    public func toDictionary() -> Dictionary<String, String> {
        return [
            "track": track,
            "artist": artist,
            "sk": sessionKey
        ]
    }
}
