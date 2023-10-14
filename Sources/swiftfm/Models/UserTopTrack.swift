import Foundation

public struct UserTopTrack: Decodable, Equatable {
    public let mbid: String
    public let name: String
    public let images: LastFMImages
    public let streamable: Bool
    public let artist: LastFMMBEntity
    public let url: URL
    public let duration: UInt
    public let rank: UInt
    public let playcount: UInt

    private enum CodingKeys: String, CodingKey {
        case mbid
        case name
        case streamable
        case artist
        case url
        case duration
        case playcount
        case attr = "@attr"
        case images = "image"

        enum StreamableKeys: String, CodingKey {
            case fulltrack
        }

        enum AttrKeys: String, CodingKey {
            case rank
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.mbid = try container.decode(String.self, forKey: CodingKeys.mbid)
        self.name = try container.decode(String.self, forKey: CodingKeys.name)
        self.images = try container.decode(LastFMImages.self, forKey: CodingKeys.images)
        self.artist = try container.decode(LastFMMBEntity.self, forKey: CodingKeys.artist)
        self.url = try container.decode(URL.self, forKey: .url)

        let attrContainer = try container.nestedContainer(keyedBy: CodingKeys.AttrKeys.self, forKey: CodingKeys.attr)
        let rankString = try attrContainer.decode(String.self, forKey: CodingKeys.AttrKeys.rank)
        let durationString = try container.decode(String.self, forKey: CodingKeys.duration)
        let playcountString = try container.decode(String.self, forKey: CodingKeys.playcount)

        guard
            let rank = UInt(rankString),
            let duration = UInt(durationString),
            let playcount = UInt(playcountString)
        else {
            throw RuntimeError("Can't parse rank, duration or playcount")
        }

        self.rank = rank
        self.duration = duration
        self.playcount = playcount

        let streamableContainer = try container.nestedContainer(keyedBy: CodingKeys.StreamableKeys.self, forKey: CodingKeys.streamable)
        let streamableString = try streamableContainer.decode(String.self, forKey: CodingKeys.StreamableKeys.fulltrack)
        self.streamable = streamableString == "1" ? true : false
    }
}
