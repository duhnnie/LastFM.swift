import Foundation

public struct UserWeeklyAlbumChart: Decodable, Equatable {

    public let mbid: String
    public let name: String
    public let artist: MBEntity
    public let url: URL
    public let playcount: UInt
    public let rank: UInt

    private enum CodingKeys: String, CodingKey {
        case mbid
        case name
        case artist
        case url
        case playcount
        case attr = "@attr"

        enum AttrKeys: String, CodingKey {
            case rank
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.mbid = try container.decode(String.self, forKey: CodingKeys.mbid)
        self.name = try container.decode(String.self, forKey: CodingKeys.name)
        self.artist = try container.decode(MBEntity.self, forKey: CodingKeys.artist)
        self.url = try container.decode(URL.self, forKey: .url)
        self.playcount = try container.decode(UInt.self, forKey: CodingKeys.playcount)

        let attrContainer = try container.nestedContainer(
            keyedBy: CodingKeys.AttrKeys.self,
            forKey: CodingKeys.attr
        )

        self.rank = try attrContainer.decode(UInt.self, forKey: CodingKeys.AttrKeys.rank)
    }

}
