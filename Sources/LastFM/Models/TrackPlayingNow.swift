import Foundation

public struct TrackPlayingNow: Decodable {

    public let artist: ScrobbledTrack.Property
    public let album: ScrobbledTrack.Property
    public let track: ScrobbledTrack.Property
    public let albumArtist: ScrobbledTrack.Property
    public let ignored: ScrobbledTrack.IgnoredType

    private enum CodingKeys: String, CodingKey {
        case nowPlaying = "nowplaying"
    }

    public init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: CodingKeys.self)
        let container = try rootContainer.nestedContainer(
            keyedBy: ScrobbledTrack.CodingKeys.self,
            forKey: .nowPlaying
        )

        let ignoredContainer = try container.nestedContainer(
            keyedBy: ScrobbledTrack.CodingKeys.IgnoredMessageKeys.self,
            forKey: .ignored
        )

        self.artist = try container.decode(ScrobbledTrack.Property.self, forKey: .artist)
        self.album = try container.decode(ScrobbledTrack.Property.self, forKey: .album)
        self.track = try container.decode(ScrobbledTrack.Property.self, forKey: .track)
        self.albumArtist = try container.decode(ScrobbledTrack.Property.self, forKey: .albumArtist)

        let ignoredCode = try ignoredContainer.decode(UInt8.self, forKey: .code)

        guard
            let ignored = ScrobbledTrack.IgnoredType(rawValue: ignoredCode)
        else {
            throw RuntimeError("Invalid ignoredMessage.code")
        }

        self.ignored = ignored
    }

}
