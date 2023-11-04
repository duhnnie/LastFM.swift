import Foundation

public struct UserInfo: Decodable {

    public let name: String
    public let age: UInt
    public let subscriber: Bool
    public let realname: String
    public let bootsrap: Bool
    public let playcount: Int
    public let artistCount: Int
    public let playlists: Int
    public let trackCount: Int
    public let albumCount: Int
    public let images: LastFMImages
    public let registered: Date
    public let country: String
    public let gender: String
    public let url: URL
    public let type: String

    private enum OuterCodingKeys: String, CodingKey {
        case user
    }

    private enum CodingKeys: String, CodingKey {
        case name
        case age
        case subscriber
        case realname
        case bootstrap
        case playcount
        case artistCount = "artist_count"
        case playlists
        case trackCount = "track_count"
        case albumCount = "album_count"
        case images = "image"
        case registered
        case country
        case gender
        case url
        case type

        enum RegisteredKeys: String, CodingKey {
            case text = "#text"
        }
    }

    public init(from decoder: Decoder) throws {
        let outerContainer = try decoder.container(keyedBy: OuterCodingKeys.self)
        let container = try outerContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .user)

        let registeredContainer = try container.nestedContainer(
            keyedBy: CodingKeys.RegisteredKeys.self,
            forKey: .registered
        )

        let ageString = try container.decode(String.self, forKey: .age)
        let subscriberString = try container.decode(String.self, forKey: .subscriber)
        let bootstrapString = try container.decode(String.self, forKey: .bootstrap)
        let playcountString = try container.decode(String.self, forKey: .playcount)
        let artistCountString = try container.decode(String.self, forKey: .artistCount)
        let playlistsString = try container.decode(String.self, forKey: .playlists)
        let trackCountString = try container.decode(String.self, forKey: .trackCount)
        let albumCountString = try container.decode(String.self, forKey: .albumCount)
        let urlString = try container.decode(String.self, forKey: .url)
        let registeredDouble = try registeredContainer.decode(Double.self, forKey: .text)

        self.name = try container.decode(String.self, forKey: .name)
        self.realname = try container.decode(String.self, forKey: .realname)
        self.images = try container.decode(LastFMImages.self, forKey: .images)
        self.country = try container.decode(String.self, forKey: .country)
        self.gender = try container.decode(String.self, forKey: .gender)
        self.type = try container.decode(String.self, forKey: .type)

        guard
            let age = UInt(ageString),
            let playcount = Int(playcountString),
            let artistCount = Int(artistCountString),
            let playlists = Int(playlistsString),
            let trackCount = Int(trackCountString),
            let albumCount = Int(albumCountString),
            let url = URL(string: urlString)
        else {
            throw RuntimeError("Can't parse all properties")
        }

        self.age = age
        self.subscriber = subscriberString == "1"
        self.bootsrap = bootstrapString == "1"
        self.playcount = playcount
        self.artistCount = artistCount
        self.playlists = playlists
        self.trackCount = trackCount
        self.albumCount = albumCount
        self.registered = Date(timeIntervalSince1970: registeredDouble)
        self.url = url
    }

}
