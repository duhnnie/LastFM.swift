import Foundation

// NOTE: this could be also URLMusicBrainzEntity
public struct ExtendedRecentTrack: Decodable {
    public let name: String
    public let artist: LastFMMBEntity
    public let album: MBEntity
    public let mbid: String
    public let url: URL
    public let images: LastFMImages
    public let date: Date?
    public let nowPlaying: Bool
    public let loved: Bool

    private enum CodingKeys: String, CodingKey {
        case name
        case artist
        case album
        case mbid
        case url
        case date
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
        self.artist = try container.decode(LastFMMBEntity.self, forKey: .artist)
        self.album = try container.decode(MBEntity.self, forKey: .album)
        self.mbid = try container.decode(String.self, forKey: .mbid)
        self.url = try container.decode(URL.self, forKey: .url)

        self.images = try container.decode(LastFMImages.self, forKey: .images)

        let lovedString = try container.decode(String.self, forKey: .loved)
        self.loved = lovedString == "1" ? true : false

        do {
            let attrContainer = try container.nestedContainer(keyedBy: CodingKeys.AttrKeys.self, forKey: .attr)

            let nowplayingString = try attrContainer.decodeIfPresent(String.self, forKey: CodingKeys.AttrKeys.nowplaying)
            self.nowPlaying = nowplayingString == "true"
        } catch {
            self.nowPlaying = false
        }

        do {
            let dateContainer = try container.nestedContainer(keyedBy: CodingKeys.DateKeys.self, forKey: CodingKeys.date)

            let utsString = try dateContainer.decode(String.self, forKey: CodingKeys.DateKeys.uts)
            guard let uts = Int(utsString) else {
                throw RuntimeError("No valid timestamp")
            }

            self.date = Date(timeIntervalSince1970: Double(uts))
        } catch {
            self.date = nil
        }
    }
}
