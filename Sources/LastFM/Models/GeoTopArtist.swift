import Foundation

public struct GeoTopArtist: Decodable, Equatable {
    public let mbid: String
    public let name: String
    public let images: LastFMImages
    public let url: URL
    public let listeners: UInt
    public let streamable: Bool

    private enum CodingKeys: String, CodingKey {
        case mbid
        case name
        case images = "image"
        case url
        case listeners
        case streamable
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.mbid = try container.decode(String.self, forKey: CodingKeys.mbid)
        self.name = try container.decode(String.self, forKey: CodingKeys.name)
        self.images = try container.decode(LastFMImages.self, forKey: CodingKeys.images)
        self.url = try container.decode(URL.self, forKey: .url)

        let listenersString = try container.decode(String.self, forKey: CodingKeys.listeners)
        let streamableString = try container.decode(String.self, forKey: CodingKeys.streamable)

        guard let listeners = UInt(listenersString) else {
            throw RuntimeError("Can't parse rank or listeners")
        }

        self.listeners = listeners
        self.streamable = streamableString == "1" ? true : false
    }
}
