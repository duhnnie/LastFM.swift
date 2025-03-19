import Foundation

public struct AlbumInfo: Decodable {

    public let mbid: String?
    public let artist: String
    public let tags: [LastFMEntity]
    public let name: String
    public let image: LastFMImages
    public let tracks: [AlbumInfoTrack]?
    public let url: URL
    public let listeners: Int
    public let playcount: Int
    public let userPlaycount: Int?
    public let wiki: Wiki?

    private enum OuterKeys: String, CodingKey {
        case album
    }

    private enum CodingKeys: String, CodingKey {
        case mbid
        case artist
        case tags
        case name
        case image
        case tracks
        case url
        case listeners
        case playcount
        case userPlaycount = "userplaycount"
        case wiki

        enum TagsKeys: String, CodingKey {
            case tag
        }

        enum TracksKeys: String, CodingKey {
            case track
        }
    }

    public init(from decoder: Decoder) throws  {
        let outerContainer = try decoder.container(keyedBy: OuterKeys.self)

        let container = try outerContainer.nestedContainer(
            keyedBy: CodingKeys.self,
            forKey: .album
        )

        if let trackContainer = try? container.nestedContainer(
            keyedBy: CodingKeys.TracksKeys.self,
            forKey: .tracks
        ) {
            // NOTE: Last.fm API returns an array of tracks when there's more than one track.
            do {
                self.tracks = try trackContainer.decodeIfPresent([AlbumInfoTrack].self, forKey: .track)
            } catch {
                let originalError = error as NSError

                do {
                    let track = try trackContainer.decode(AlbumInfoTrack.self, forKey: .track)  
                    self.tracks = [track]
                } catch {
                    throw originalError
                }
            }
        } else {
            self.tracks = nil
        }

        self.mbid = try container.decodeIfPresent(String.self, forKey: .mbid)
        self.artist = try container.decode(String.self, forKey: .artist)
        self.name = try container.decode(String.self, forKey: .name)
        self.image = try container.decode(LastFMImages.self, forKey: .image)
        self.url = try container.decode(URL.self, forKey: .url)
        self.listeners = try container.decode(Int.self, forKey: .listeners)
        self.playcount = try container.decode(Int.self, forKey: .playcount)
        self.userPlaycount = try container.decodeIfPresent(Int.self, forKey: .userPlaycount)
        self.wiki = try container.decodeIfPresent(Wiki.self, forKey: .wiki)

        do {
            // NOTE: When there's no tags in current response,
            // Last.fm sends an empty string.
            let tagsContainer = try container.nestedContainer(
                keyedBy: CodingKeys.TagsKeys.self,
                forKey: .tags
            )

            self.tags = try tagsContainer.decode([LastFMEntity].self, forKey: .tag)
        } catch {
            self.tags = []
        }
    }

}
