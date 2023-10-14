import Foundation

public struct LovedTrack: Decodable, Equatable {
    public let mbid: String
    public let name: String
    public let artist: LastFMMBEntity
    public let images: LastFMImages
    public let url: URL
    public let date: Date
    public let streamable: Bool

    private enum CodingKeys: String, CodingKey {
        case mbid
        case name
        case artist
        case images = "image"
        case url
        case date
        case streamable

        enum StreamableKeys: String, CodingKey {
            case fulltrack
        }

        enum DateKeys: String, CodingKey {
            case uts
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let streamableContainer = try container.nestedContainer(
            keyedBy: CodingKeys.StreamableKeys.self,
            forKey: .streamable
        )

        let dateContainer = try container.nestedContainer(
            keyedBy: CodingKeys.DateKeys.self,
            forKey: .date
        )

        let streamableString = try streamableContainer.decode(String.self, forKey: .fulltrack)
        let utsString = try dateContainer.decode(String.self, forKey: .uts)

        self.mbid = try container.decode(String.self, forKey: .mbid)
        self.name = try container.decode(String.self, forKey: .name)
        self.artist = try container.decode(LastFMMBEntity.self, forKey: .artist)
        self.images = try container.decode(LastFMImages.self, forKey: .images)
        self.url = try container.decode(URL.self, forKey: .url)
        self.streamable = streamableString == "1"

        guard let uts = UInt(utsString) else {
            throw RuntimeError("No valid date")
        }

        self.date = Date(timeIntervalSince1970: Double(uts))
    }
}
