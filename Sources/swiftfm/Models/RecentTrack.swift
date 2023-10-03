import Foundation

// NOTE: this could be also URLMusicBrainzEntity
public struct RecentTrack<Artist: MusicBrainz>: RecentTrackProtocol {
    public let name: String
    public let artist: Artist
    public let album: MusicBrainzEntity
    public let mbid: String?
    public let url: URL
    public let images: LastFMImages?
    public let date: Date?
    public let nowPlaying: Bool

    private enum CodingKeys: String, CodingKey {
        case name
        case artist
        case album
        case mbid
        case url
        case date
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
        self.artist = try container.decode(Artist.self, forKey: .artist)
        self.album = try container.decode(MusicBrainzEntity.self, forKey: .album)
        self.mbid = try container.decode(String.self, forKey: .mbid)
        self.url = try container.decode(URL.self, forKey: .url)

        let images = try container.decode(LastFMImages.self, forKey: .images)
        self.images = images.hasImages ? images : nil

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
