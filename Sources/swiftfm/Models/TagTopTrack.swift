import Foundation

public struct TagTopTrack: Decodable, Equatable {
    public let mbid: String
    public let name: String
    public let artist: LastFMMBEntity
    public let images: LastFMImages
    public let url: URL
    public let duration: UInt
    public let streammable: Bool
    public let rank: UInt

    public enum CodingKeys: String, CodingKey {
        case mbid
        case name
        case artist
        case images = "image"
        case url
        case duration
        case streamable
        case attr = "@attr"

        enum StreamableKeys: String, CodingKey {
            case fulltrack
        }

        enum AttrKeys: String, CodingKey {
            case rank
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let durationString = try container.decode(String.self, forKey: .duration)

        let streamableContainer = try container.nestedContainer(
            keyedBy: CodingKeys.StreamableKeys.self,
            forKey: .streamable
        )

        let rankContainer = try container.nestedContainer(
            keyedBy: CodingKeys.AttrKeys.self,
            forKey: .attr
        )

        let streamableString = try streamableContainer.decode(String.self, forKey: .fulltrack)
        let rankString =  try rankContainer.decode(String.self, forKey: .rank)

        self.mbid = try container.decode(String.self, forKey: .mbid)
        self.name = try container.decode(String.self, forKey: .name)
        self.artist = try container.decode(LastFMMBEntity.self, forKey: .artist)
        self.images = try container.decode(LastFMImages.self, forKey: .images)
        self.url = try container.decode(URL.self, forKey: .url)
        self.streammable = streamableString == "1"

        guard
            let duration = UInt(durationString),
            let rank = UInt(rankString)
        else {
            throw RuntimeError("Invalid duration or rank")
        }

        self.duration = duration
        self.rank = rank
    }
}
