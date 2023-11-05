import Foundation

public struct TrackNowPlayingParams: Params {

    public var artist: String
    public var track: String
    public var album: String?
    public var context: String?
    public var trackNumber: UInt?
    public var mbid: String?
    public var albumArtist: String?
    public var duration: UInt?
    public var sessionKey: String

    public init(
        artist: String,
        track: String,
        album: String? = nil,
        context: String? = nil,
        trackNumber: UInt? = nil,
        mbid: String? = nil,
        albumArtist: String? = nil,
        duration: UInt? = nil,
        sessionKey: String
    ) {
        self.artist = artist
        self.track = track
        self.album = album
        self.context = context
        self.trackNumber = trackNumber
        self.mbid = mbid
        self.albumArtist = albumArtist
        self.duration = duration
        self.sessionKey = sessionKey
    }

    internal func toDictionary() -> Dictionary<String, String> {
        var dict: [String: String] = [
            "artist": artist,
            "track": track,
            "sk": sessionKey
        ]

        if let album = album {
            dict["album"] = album
        }

        if let context = context {
            dict["context"] = context
        }

        if let trackNumber = trackNumber {
            dict["trackNumber"] = String(trackNumber)
        }

        if let mbid = mbid {
            dict["mbid"] = mbid
        }

        if let albumArtist = albumArtist {
            dict["albumArtist"] = albumArtist
        }

        if let duration = duration {
            dict["duration"] = String(duration)
        }

        return dict
    }

}
