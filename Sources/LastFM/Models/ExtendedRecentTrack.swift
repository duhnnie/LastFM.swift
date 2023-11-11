import Foundation

// NOTE: this could be also URLMusicBrainzEntity
public struct ExtendedRecentTrack: Decodable {

    public let name: String
    public let artist: LastFMMBExtendedEntity
    public let album: MBEntity
    public let mbid: String
    public let url: URL
    public let images: LastFMImages
    public let date: Date?
    public let nowPlaying: Bool
    public let streamable: Bool
    public let loved: Bool

    private enum CodingKeys: String, CodingKey {
        case name
        case artist
        case album
        case mbid
        case url
        case date
        case streamable
        case loved
        case images = "image"
        case attr = "@attr"

        enum AttrKeys: String, CodingKey {
            case nowplaying
        }

        enum DateKeys: String, CodingKey {
            case uts
        }
    }

    public init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.name = try container.decode(String.self, forKey: .name)
        self.artist = try container.decode(LastFMMBExtendedEntity.self, forKey: .artist)
        self.album = try container.decode(MBEntity.self, forKey: .album)
        self.mbid = try container.decode(String.self, forKey: .mbid)
        self.url = try container.decode(URL.self, forKey: .url)
        self.streamable = try container.decode(Bool.self, forKey: .streamable)
        self.loved = try container.decode(Bool.self, forKey: .loved)

        self.images = try container.decode(LastFMImages.self, forKey: .images)

        if let attrContainer = try? container.nestedContainer(keyedBy: CodingKeys.AttrKeys.self, forKey: .attr) {
            self.nowPlaying = try attrContainer.decode(
                Bool.self,
                forKey: .nowplaying
            )
        } else {
            self.nowPlaying = false
        }

        if let dateContainer = try? container.nestedContainer(
            keyedBy: CodingKeys.DateKeys.self,
            forKey: CodingKeys.date
        ) {
            let uts = try dateContainer.decode(
                Int.self,
                forKey: CodingKeys.DateKeys.uts
            )

            self.date = Date(timeIntervalSince1970: Double(uts))
        } else {
            self.date = nil
        }
    }

}
