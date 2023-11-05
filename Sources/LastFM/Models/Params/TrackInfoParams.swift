import Foundation

public struct TrackInfoParams: Params {

    public var artist: String
    public var track: String
    public var username: String?
    public var autocorrect: Bool

    public init(artist: String, track: String, autocorrect: Bool = true, username: String? = nil) {
        self.artist = artist
        self.track = track
        self.autocorrect = autocorrect
        self.username = username
    }

    internal func toDictionary() -> Dictionary<String, String> {
        var dict = [
            "artist": self.artist,
            "track": self.track,
            "autocorrect": self.autocorrect ? "1" : "0"
        ]

        if let username = username {
            dict["username"] = username
        }

        return dict
    }

}
