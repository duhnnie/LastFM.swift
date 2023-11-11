import Foundation

public struct ScrobbledTrack: Decodable {

    public enum IgnoredType: UInt8, Decodable {
        case NotIgnored = 0
        case ArtistIgnored = 1
        case TrackIgnored = 2
        case TimestampTooOld = 3
        case TimestampTooNew = 4
        case DailyScrobbleLimitExceeded = 5
    }

    public struct Property: Decodable {
        public let text: String?
        public let corrected: Bool

        enum CodingKeys: String, CodingKey {
            case text = "#text"
            case corrected
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let correctedString = try container.decode(String.self, forKey: .corrected)

            self.text = try container.decodeIfPresent(String.self, forKey: .text)
            self.corrected = correctedString == "1"
        }
    }

    internal enum CodingKeys: String, CodingKey {
        case artist
        case album
        case track
        case ignored = "ignoredMessage"
        case albumArtist
        case timestamp

        enum NestedKeys: String, CodingKey {
            case corrected
            case value = "#text"
        }

        enum IgnoredMessageKeys: String, CodingKey {
            case code
        }
    }

    public let artist: Property
    public let album: Property
    public let track: Property
    public let albumArtist: Property
    public let timestamp: UInt
    public let ignored: IgnoredType

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let ignoredContainer = try container.nestedContainer(
            keyedBy: CodingKeys.IgnoredMessageKeys.self,
            forKey: .ignored
        )

        self.artist = try container.decode(Property.self, forKey: .artist)
        self.album = try container.decode(Property.self, forKey: .album)
        self.track = try container.decode(Property.self, forKey: .track)
        self.albumArtist = try container.decode(Property.self, forKey: .albumArtist)
        self.timestamp = try container.decode(UInt.self, forKey: .timestamp)

        let ignoredCode = try ignoredContainer.decode(UInt8.self, forKey: .code)

        guard
            let ignored = IgnoredType(rawValue: ignoredCode)
        else {
            throw RuntimeError("Invalid ignoredMessage.code")
        }


        self.ignored = ignored
    }

}
