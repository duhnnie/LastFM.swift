import Foundation

public struct AlbumInfoTrack: Decodable {

    public let name: String
    public let url: URL
    public let duration: UInt
    public let trackNumber: UInt
    public let streamable: Streamable
    public let artist: LastFMMBEntity

    private enum CodingKeys: String, CodingKey {
        case name
        case url
        case duration
        case streamable
        case attr = "@attr"
        case artist

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

        self.name = try container.decode(String.self, forKey: .name)
        self.url = try container.decode(URL.self, forKey: .url)
        self.duration = try container.decode(UInt.self, forKey: .duration)
        self.streamable = try container.decode(Streamable.self, forKey: .streamable)
        self.artist = try container.decode(LastFMMBEntity.self, forKey: .artist)
        self.trackNumber = try attrContainer.decode(UInt.self, forKey: .rank)
    }

}
