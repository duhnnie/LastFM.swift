import Foundation

public struct ChartTopTrack: Decodable, Equatable {

    public let mbid: String
    public let name: String
    public let artist: LastFMMBEntity
    public let images: LastFMImages
    public let duration: UInt
    public let url: URL
    public let streamable: Bool
    public let playcount: UInt
    public let listeners: UInt

    private enum CodingKeys: String, CodingKey {
        case mbid
        case name
        case artist
        case images = "image"
        case duration
        case url
        case streamable
        case playcount
        case listeners

        enum StreamableKeys: String, CodingKey {
            case fulltrack
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let streamableContainer = try container.nestedContainer(
            keyedBy: CodingKeys.StreamableKeys.self,
            forKey: .streamable
        )

        let durationString = try container.decode(String.self, forKey: .duration)
        let listenersString = try container.decode(String.self, forKey: .listeners)
        let streamableString = try streamableContainer.decode(String.self, forKey: .fulltrack)
        let playcountString = try container.decode(String.self, forKey: .playcount)

        self.mbid = try container.decode(String.self, forKey: .mbid)
        self.name = try container.decode(String.self, forKey: .name)
        self.artist = try container.decode(LastFMMBEntity.self, forKey: .artist)
        self.images = try container.decode(LastFMImages.self, forKey: .images)
        self.url = try container.decode(URL.self, forKey: .url)
        self.streamable = streamableString == "1"

        guard
            let duration = UInt(durationString),
            let listeners = UInt(listenersString),
            let playcount = UInt(playcountString)
        else {
            throw RuntimeError("invalid duration, listeners or rank")
        }

        self.duration = duration
        self.listeners = listeners
        self.playcount = playcount
    }
}
