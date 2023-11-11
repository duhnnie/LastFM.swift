import Foundation

public struct TagTopTrack: Decodable {

    public let mbid: String
    public let name: String
    public let artist: LastFMMBEntity
    public let images: LastFMImages
    public let url: URL
    public let duration: UInt
    public let streamable: Streamable
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

        enum AttrKeys: String, CodingKey {
            case rank
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let rankContainer = try container.nestedContainer(
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
        self.rank =  try rankContainer.decode(UInt.self, forKey: .rank)
    }

}
