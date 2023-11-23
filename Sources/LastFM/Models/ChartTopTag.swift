import Foundation

public struct ChartTopTag: Decodable {

    public let name: String
    public let url: URL
    public let reach: UInt
    public let taggings: UInt
    public let streamable: Bool
    public let wiki: Wiki?

    private enum CodingKeys: String, CodingKey {
        case name
        case url
        case reach
        case taggings
        case streamable
        case wiki
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.name = try container.decode(String.self, forKey: .name)
        self.url = try container.decode(URL.self, forKey: .url)
        self.reach = try container.decode(UInt.self, forKey: .reach)
        self.taggings = try container.decode(UInt.self, forKey: .taggings)
        self.streamable = try container.decode(Bool.self, forKey: .streamable)

        do {
            // NOTE: LastFM returns an empty object here, so it always will fail.
            // We set it to nil in that case
            self.wiki = try container.decodeIfPresent(Wiki.self, forKey: .wiki)
        } catch {
            self.wiki = nil
        }
    }

}
