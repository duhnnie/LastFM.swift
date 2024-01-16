import Foundation

public struct UserInfo: Codable {

    public let name: String
    public let age: UInt
    public let subscriber: Bool
    public let realname: String
    public let bootstrap: Bool
    public let playcount: UInt
    public let artistCount: UInt
    public let playlists: UInt
    public let trackCount: UInt
    public let albumCount: UInt
    public let image: LastFMImages
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
        case image
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

        self.name = try container.decode(String.self, forKey: .name)
        self.realname = try container.decode(String.self, forKey: .realname)
        self.image = try container.decode(LastFMImages.self, forKey: .image)
        self.country = try container.decode(String.self, forKey: .country)
        self.gender = try container.decode(String.self, forKey: .gender)
        self.type = try container.decode(String.self, forKey: .type)

        self.age = try container.decode(UInt.self, forKey: .age)
        self.subscriber = try container.decode(Bool.self, forKey: .subscriber)
        self.bootstrap = try container.decode(Bool.self, forKey: .bootstrap)
        self.playcount = try container.decode(UInt.self, forKey: .playcount)
        self.artistCount = try container.decode(UInt.self, forKey: .artistCount)
        self.playlists = try container.decode(UInt.self, forKey: .playlists)
        self.trackCount = try container.decode(UInt.self, forKey: .trackCount)
        self.albumCount = try container.decode(UInt.self, forKey: .albumCount)
        self.url = try container.decode(URL.self, forKey: .url)

        let registeredDouble = try registeredContainer.decode(Double.self, forKey: .text)

        self.registered = Date(timeIntervalSince1970: registeredDouble)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: OuterCodingKeys.self)
        var subcontainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .user)
        
        var subsubcontainer = subcontainer.nestedContainer(
            keyedBy: CodingKeys.RegisteredKeys.self,
            forKey: .registered
        )
        
        try subcontainer.encode(name, forKey: .name)
        try subcontainer.encode(age, forKey: .age)
        try subcontainer.encode(subscriber, forKey: .subscriber)
        try subcontainer.encode(name, forKey: .name)
        try subcontainer.encode(age, forKey: .age)
        try subcontainer.encode(subscriber, forKey: .subscriber)
        try subcontainer.encode(realname, forKey: .realname)
        try subcontainer.encode(bootstrap, forKey: .bootstrap)
        try subcontainer.encode(playcount, forKey: .playcount)
        try subcontainer.encode(artistCount, forKey: .artistCount)
        try subcontainer.encode(playlists, forKey: .playlists)
        try subcontainer.encode(trackCount, forKey: .trackCount)
        try subcontainer.encode(albumCount, forKey: .albumCount)
        try subcontainer.encode(image, forKey: .image)
        try subcontainer.encode(country, forKey: .country)
        try subcontainer.encode(gender, forKey: .gender)
        try subcontainer.encode(url, forKey: .url)
        try subcontainer.encode(type, forKey: .type)
        try subsubcontainer.encode(registered, forKey: .text)
    }

}
