import Foundation

public struct ArtistTopTrack: Decodable, Equatable {

    public let mbid: String?
    public let name: String
    public let artist: LastFMOptionalMBEntity
    public let images: LastFMImages
    public let url: URL
    public let streamable: Bool
    public let playcount: UInt
    public let listeners: UInt
    public let rank: UInt

    private enum CodingKeys: String, CodingKey {
        case mbid
        case name
        case artist
        case images = "image"
        case url
        case streamable
        case playcount
        case listeners
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

        self.mbid = try container.decodeIfPresent(String.self, forKey: .mbid)
        self.name = try container.decode(String.self, forKey: .name)
        self.artist = try container.decode(LastFMOptionalMBEntity.self, forKey: .artist)
        self.images = try container.decode(LastFMImages.self, forKey: .images)
        self.url = try container.decode(URL.self, forKey: .url)
        self.streamable = try container.decode(Bool.self, forKey: .streamable)

        self.rank = try attrContainer.decode(UInt.self, forKey: .rank)
        self.playcount = try container.decode(UInt.self, forKey: .playcount)
        self.listeners = try container.decode(UInt.self, forKey: .listeners)
    }
}
