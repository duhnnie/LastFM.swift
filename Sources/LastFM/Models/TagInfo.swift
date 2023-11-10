import Foundation

public struct TagInfo: Decodable {

    public let name: String
    public let reach: Int
    public let total: Int
    public let wiki: SimpleWiki

    private enum OuterKeys: String, CodingKey {
        case tag
    }

    private enum CodingKeys: String, CodingKey {
        case name
        case reach
        case total
        case wiki
    }

    public init(from decoder: Decoder) throws {
        let outerContainer = try decoder.container(keyedBy: OuterKeys.self)
        let container = try outerContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .tag)

        self.name = try container.decode(String.self, forKey: .name)
        self.reach = try container.decode(Int.self, forKey: .reach)
        self.total = try container.decode(Int.self, forKey: .total)
        self.wiki = try container.decode(SimpleWiki.self, forKey: .wiki)
    }

}
