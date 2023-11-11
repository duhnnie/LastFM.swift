import Foundation

public struct GeoTopTrack: Decodable {

    public let mbid: String
    public let name: String
    public let artist: LastFMMBEntity
    public let images: LastFMImages
    public let duration: UInt
    public let url: URL
    public let streamable: Streamable
    public let listeners: UInt
    public let rank: UInt

    private enum CodingKeys: String, CodingKey {
        case mbid
        case name
        case artist
        case images = "image"
        case duration
        case url
        case streamable
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

        self.mbid = try container.decode(String.self, forKey: .mbid)
        self.name = try container.decode(String.self, forKey: .name)
        self.artist = try container.decode(LastFMMBEntity.self, forKey: .artist)
        self.images = try container.decode(LastFMImages.self, forKey: .images)
        self.url = try container.decode(URL.self, forKey: .url)
        self.streamable = try container.decode(Streamable.self, forKey: .streamable)
        self.duration = try container.decode(UInt.self, forKey: .duration)
        self.listeners = try container.decode(UInt.self, forKey: .listeners)
        self.rank = try attrContainer.decode(UInt.self, forKey: .rank)
    }

}
