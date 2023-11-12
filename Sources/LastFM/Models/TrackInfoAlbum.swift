import Foundation

public struct TrackInfoAlbum: Decodable {

    public let artist: String
    public let title: String
    public let mbid: String?
    public let url: URL
    public let image: LastFMImages
    public let position: UInt?

    private enum CodingKeys: String, CodingKey {
        case artist
        case title
        case mbid
        case url
        case image
        case attr = "@attr"

        enum AttrKeys: String, CodingKey {
            case position
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.artist = try container.decode(String.self, forKey: .artist)
        self.title = try container.decode(String.self, forKey: .title)
        self.mbid = try container.decodeIfPresent(String.self, forKey: .mbid)
        self.url = try container.decode(URL.self, forKey: .url)
        self.image = try container.decode(LastFMImages.self, forKey: .image)

        guard
            let attrContainer = try? container.nestedContainer(keyedBy: CodingKeys.AttrKeys.self, forKey: .attr)
        else {
            self.position = nil
            return
        }

        self.position = try attrContainer.decode(UInt.self, forKey: .position)
    }
    
}
