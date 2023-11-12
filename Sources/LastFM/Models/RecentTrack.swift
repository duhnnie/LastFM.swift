import Foundation

// NOTE: this could be also URLMusicBrainzEntity
public struct RecentTrack: Decodable {

    public let name: String
    public let artist: MBEntity
    public let album: MBEntity
    public let mbid: String
    public let url: URL
    public let image: LastFMImages
    public let date: Date?
    public let nowPlaying: Bool
    public let streamable: Bool

    private enum CodingKeys: String, CodingKey {
        case name
        case artist
        case album
        case mbid
        case url
        case date
        case streamable
        case image
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
        self.artist = try container.decode(MBEntity.self, forKey: .artist)
        self.album = try container.decode(MBEntity.self, forKey: .album)
        self.mbid = try container.decode(String.self, forKey: .mbid)
        self.url = try container.decode(URL.self, forKey: .url)
        self.streamable = try container.decode(Bool.self, forKey: .streamable)

        self.image = try container.decode(LastFMImages.self, forKey: .image)

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
