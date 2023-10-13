import Foundation

public struct UserWeeklyChartTrack: Decodable {
    public let mbid: String
    public let name: String
    public let url: URL
    public let artist: MBEntity
    public let images: LastFMImages
    public let playcount: UInt
    public let rank: UInt

    private enum CodingKeys: String, CodingKey {
        case mbid
        case name
        case url
        case artist
        case images = "image"
        case playcount
        case attr = "@attr"

        enum AttrKeys: String, CodingKey {
            case rank
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let attrContainer = try container.nestedContainer(
            keyedBy: CodingKeys.AttrKeys.self,
            forKey: .attr
        )

        let playcountString = try container.decode(String.self, forKey: .playcount)
        let rankString = try attrContainer.decode(String.self, forKey: .rank)

        self.mbid = try container.decode(String.self, forKey: .mbid)
        self.name = try container.decode(String.self, forKey: .name)
        self.url = try container.decode(URL.self, forKey: .url)
        self.artist = try container.decode(MBEntity.self, forKey: .artist)
        self.images = try container.decode(LastFMImages.self, forKey: .images)

        guard let playcount = UInt(playcountString) else {
            throw RuntimeError("Invalid playcount.")
        }

        guard let rank = UInt(rankString) else {
            throw RuntimeError("Invalid rank.")
        }

        self.playcount = playcount
        self.rank = rank
    }
}
