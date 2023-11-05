import Foundation

public struct TrackInfo: Decodable {

    public let name: String
    public let mbid: String?
    public let url: URL
    public let duration: Int
    public let streamable: Bool
    public let listeners: Int
    public let playcount: Int
    public let artist: LastFMOptionalMBEntity
    public let album: TrackInfoAlbum
    public let topTags: [LastFMEntity]
    public let wiki: Wiki?
    public let userPlaycount: Int?
    public let userLoved: Bool?

    private enum CodingKeys: String, CodingKey {
        case track

        enum TrackInfoKeys: String, CodingKey {
            case name
            case mbid
            case url
            case duration
            case streamable = "streamable"
            case listeners
            case playcount
            case artist
            case album
            case topTags = "toptags"
            case wiki
            case userPlaycount = "userplaycount"
            case userLoved = "userloved"

            enum StreamableKeys: String, CodingKey {
                case text = "#text"
            }

            enum TopTagsKeys: String, CodingKey {
                case tags = "tag"
            }
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let subcontainer = try container.nestedContainer(
            keyedBy: CodingKeys.TrackInfoKeys.self,
            forKey: .track
        )

        let streamableContainer = try subcontainer.nestedContainer(
            keyedBy: CodingKeys.TrackInfoKeys.StreamableKeys.self,
            forKey: .streamable
        )

        let topTagsContainer = try subcontainer.nestedContainer(
            keyedBy: CodingKeys.TrackInfoKeys.TopTagsKeys.self,
            forKey: .topTags
        )

        let streamableString = try streamableContainer.decode(String.self, forKey: .text)

        self.name = try subcontainer.decode(String.self, forKey: .name)
        self.mbid = try subcontainer.decodeIfPresent(String.self, forKey: .mbid)
        self.url = try subcontainer.decode(URL.self, forKey: .url)
        self.duration = try subcontainer.decode(Int.self, forKey: .duration)
        self.streamable = streamableString != "0"
        self.listeners = try subcontainer.decode(Int.self, forKey: .listeners)
        self.playcount = try subcontainer.decode(Int.self, forKey: .playcount)
        self.artist = try subcontainer.decode(LastFMOptionalMBEntity.self, forKey: .artist)
        self.album = try subcontainer.decode(TrackInfoAlbum.self, forKey: .album)
        self.topTags = try topTagsContainer.decode([LastFMEntity].self, forKey: .tags)
        self.wiki = try subcontainer.decodeIfPresent(Wiki.self, forKey: .wiki)
        self.userPlaycount = try subcontainer.decodeIfPresent(Int.self, forKey: .userPlaycount)
        self.userLoved = try subcontainer.decodeIfPresent(Bool.self, forKey: .userLoved)
    }

}
