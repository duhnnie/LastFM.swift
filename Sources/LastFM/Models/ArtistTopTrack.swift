import Foundation

public struct ArtistTopTrack: Decodable, Equatable {

    public let mbid: String?
    public let name: String
    public let artist: LastFMOptionalMBEntity
    public let images: LastFMImages
    public let url: URL
    public let streamable: Bool
    public let playcount: UInt
    public let listeners: UInt
    public let rank: UInt

    private enum CodingKeys: String, CodingKey {
        case mbid
        case name
        case artist
        case images = "image"
        case url
        case streamable
        case playcount
        case listeners
        case attr = "@attr"

        enum AttrKeys: String, CodingKey {
            case rank
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let attrContainer = try container.nestedContainer(
            keyedBy: CodingKeys.AttrKeys.self,
            forKey: .attr
        )

        let streamableString = try container.decode(String.self, forKey: .streamable)
        let playcountString = try container.decode(String.self, forKey: .playcount)
        let rankString =  try attrContainer.decode(String.self, forKey: .rank)
        let listenersString = try container.decode(String.self, forKey: .listeners)

        self.mbid = try container.decodeIfPresent(String.self, forKey: .mbid)
        self.name = try container.decode(String.self, forKey: .name)
        self.artist = try container.decode(LastFMOptionalMBEntity.self, forKey: .artist)
        self.images = try container.decode(LastFMImages.self, forKey: .images)
        self.url = try container.decode(URL.self, forKey: .url)
        self.streamable = streamableString == "1"

        guard
            let rank = UInt(rankString),
            let playcount = UInt(playcountString),
            let listeners = UInt(listenersString)
        else {
            throw RuntimeError("Invalid rank, playcount or listeners")
        }

        self.rank = rank
        self.playcount = playcount
        self.listeners = listeners
    }
}
