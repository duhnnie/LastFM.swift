import Foundation

public struct ArtistSimilar: Decodable, Equatable {

    public let mbid: String
    public let name: String
    public let images: LastFMImages
    public let url: URL
    public let match: Float
    public let streamable: Bool

    private enum CodingKeys: String, CodingKey {
        case mbid
        case name
        case images = "image"
        case url
        case match
        case streamable
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.mbid = try container.decode(String.self, forKey: CodingKeys.mbid)
        self.name = try container.decode(String.self, forKey: CodingKeys.name)
        self.images = try container.decode(LastFMImages.self, forKey: CodingKeys.images)
        self.url = try container.decode(URL.self, forKey: .url)

        let matchString = try container.decode(String.self, forKey: CodingKeys.match)
        let streamableString = try container.decode(String.self, forKey: CodingKeys.streamable)

        guard let match = Float(matchString) else {
            throw RuntimeError("Can't parse match property")
        }

        self.match = match
        self.streamable = streamableString == "1" ? true : false
    }

}
