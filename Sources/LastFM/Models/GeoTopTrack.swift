import Foundation

public struct GeoTopTrack: Decodable, Equatable {

    public let mbid: String
    public let name: String
    public let artist: LastFMMBEntity
    public let images: LastFMImages
    public let duration: UInt
    public let url: URL
    public let streamable: Bool
    public let listeners: UInt
    public let rank: UInt

    private enum CodingKeys: String, CodingKey {
        case mbid
        case name
        case artist
        case images = "image"
        case duration
        case url
        case streamable
        case listeners
        case attr = "@attr"

        enum StreamambleKeys: String, CodingKey {
            case fulltrack
        }

        enum AttrKeys: String, CodingKey {
            case rank
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let streamableContainer = try container.nestedContainer(
            keyedBy: CodingKeys.StreamambleKeys.self,
            forKey: .streamable
        )

        let attrContainer = try container.nestedContainer(
            keyedBy: CodingKeys.AttrKeys.self,
            forKey: .attr
        )

        let durationString = try container.decode(String.self, forKey: .duration)
        let listenersString = try container.decode(String.self, forKey: .listeners)
        let streamableString = try streamableContainer.decode(String.self, forKey: .fulltrack)
        let rankString = try attrContainer.decode(String.self, forKey: .rank)

        self.mbid = try container.decode(String.self, forKey: .mbid)
        self.name = try container.decode(String.self, forKey: .name)
        self.artist = try container.decode(LastFMMBEntity.self, forKey: .artist)
        self.images = try container.decode(LastFMImages.self, forKey: .images)
        self.url = try container.decode(URL.self, forKey: .url)
        self.streamable = streamableString == "1"

        guard
            let duration = UInt(durationString),
            let listeners = UInt(listenersString),
            let rank = UInt(rankString)
        else {
            throw RuntimeError("invalid duration, listeners or rank")
        }

        self.duration = duration
        self.listeners = listeners
        self.rank = rank
    }
}
