import Foundation

public struct TagTopAlbum: Decodable {

    public let mbid: String
    public let name: String
    public let artist: LastFMMBEntity
    public let images: LastFMImages
    public let url: URL
    public let rank: UInt

    private enum CodingKeys: String, CodingKey {
        case mbid
        case name
        case artist
        case images = "image"
        case url
        case attr = "@attr"

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
        self.rank = try attrContainer.decode(UInt.self, forKey: CodingKeys.AttrKeys.rank)
    }

}
