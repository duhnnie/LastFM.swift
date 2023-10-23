import Foundation

public struct UserTopArtist: Decodable, Equatable {
    public let mbid: String
    public let name: String
    public let images: LastFMImages
    public let url: URL
    public let playcount: UInt
    public let streamable: Bool
    public let rank: UInt

    private enum CodingKeys: String, CodingKey {
        case mbid
        case name
        case images = "image"
        case url
        case playcount
        case streamable
        case attr = "@attr"

        enum AttrKeys: String, CodingKey {
            case rank
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.mbid = try container.decode(String.self, forKey: CodingKeys.mbid)
        self.name = try container.decode(String.self, forKey: CodingKeys.name)
        self.images = try container.decode(LastFMImages.self, forKey: CodingKeys.images)
        self.url = try container.decode(URL.self, forKey: .url)

        let attrContainer = try container.nestedContainer(keyedBy: CodingKeys.AttrKeys.self, forKey: CodingKeys.attr)
        let rankString = try attrContainer.decode(String.self, forKey: CodingKeys.AttrKeys.rank)
        let playcountString = try container.decode(String.self, forKey: CodingKeys.playcount)
        let streamableString = try container.decode(String.self, forKey: CodingKeys.streamable)

        guard
            let rank = UInt(rankString),
            let playcount = UInt(playcountString)
        else {
            throw RuntimeError("Can't parse rank or playcount")
        }

        self.rank = rank
        self.playcount = playcount

        self.streamable = streamableString == "1" ? true : false
    }
}
