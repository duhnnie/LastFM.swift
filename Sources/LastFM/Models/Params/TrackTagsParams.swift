import Foundation

public struct TrackTagsParams: Params {

    let artist: String
    let track: String
    let tags: [String]

    public init(artist: String, track: String, tags: [String]) {
        self.artist = artist
        self.track = track
        self.tags = tags
    }

    public func toDictionary() -> Dictionary<String, String> {
        return [
            "artist": self.artist,
            "track": self.track,
            "tags": self.tags.joined(separator: ",")
        ]
    }

}
