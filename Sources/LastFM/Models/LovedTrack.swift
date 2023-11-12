import Foundation

public struct LovedTrack: Decodable {

    public let mbid: String
    public let name: String
    public let artist: LastFMMBEntity
    public let images: LastFMImages
    public let url: URL
    public let date: Date
    public let streamable: Streamable

    private enum CodingKeys: String, CodingKey {
        case mbid
        case name
        case artist
        case images = "image"
        case url
        case date
        case streamable

        enum DateKeys: String, CodingKey {
            case uts
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let dateContainer = try container.nestedContainer(
            keyedBy: CodingKeys.DateKeys.self,
            forKey: .date
        )

        let uts = try dateContainer.decode(UInt.self, forKey: .uts)

        self.mbid = try container.decode(String.self, forKey: .mbid)
        self.name = try container.decode(String.self, forKey: .name)
        self.artist = try container.decode(LastFMMBEntity.self, forKey: .artist)
        self.images = try container.decode(LastFMImages.self, forKey: .images)
        self.url = try container.decode(URL.self, forKey: .url)
        self.streamable = try container.decode(Streamable.self, forKey: .streamable)
        self.date = Date(timeIntervalSince1970: Double(uts))
    }

}
