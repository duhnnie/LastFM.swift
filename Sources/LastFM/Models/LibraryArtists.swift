import Foundation

public struct LibraryArtist: Decodable, Equatable {
    public let mbid: String
    public let name: String
    public let images: LastFMImages
    public let url: URL
    public let playcount: UInt
    public let streamable: Bool
    public let tagcount: UInt

    private enum CodingKeys: String, CodingKey {
        case mbid
        case name
        case images = "image"
        case url
        case playcount
        case streamable
        case tagcount
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.mbid = try container.decode(String.self, forKey: CodingKeys.mbid)
        self.name = try container.decode(String.self, forKey: CodingKeys.name)
        self.images = try container.decode(LastFMImages.self, forKey: CodingKeys.images)
        self.url = try container.decode(URL.self, forKey: .url)

        let tagcountString = try container.decode(String.self, forKey: CodingKeys.tagcount)
        let playcountString = try container.decode(String.self, forKey: CodingKeys.playcount)
        let streamableString = try container.decode(String.self, forKey: CodingKeys.streamable)

        guard
            let tagcount = UInt(tagcountString),
            let playcount = UInt(playcountString)
        else {
            throw RuntimeError("Can't parse tagcount or playcount")
        }

        self.tagcount = tagcount
        self.playcount = playcount
        self.streamable = streamableString == "1" ? true : false
    }
}
