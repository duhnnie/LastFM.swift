import Foundation

// NOTE: this could be also URLMusicBrainzEntity
public struct ExtendedRecentTrack: Codable {

    public let name: String
    public let artist: LastFMMBExtendedEntity
    public let album: MBEntity
    public let mbid: String
    public let url: URL
    public let image: LastFMImages
    public let date: Date?
    public let nowPlaying: Bool
    public let streamable: Bool
    public let loved: Bool

    private enum CodingKeys: String, CodingKey {
        case name
        case artist
        case album
        case mbid
        case url
        case date
        case streamable
        case loved
        case image
        case attr = "@attr"

        enum AttrKeys: String, CodingKey {
            case nowplaying
        }

        enum DateKeys: String, CodingKey {
            case uts
            case text = "#text"
        }
    }

    public init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.name = try container.decode(String.self, forKey: .name)
        self.artist = try container.decode(LastFMMBExtendedEntity.self, forKey: .artist)
        self.album = try container.decode(MBEntity.self, forKey: .album)
        self.mbid = try container.decode(String.self, forKey: .mbid)
        self.url = try container.decode(URL.self, forKey: .url)
        self.streamable = try container.decode(Bool.self, forKey: .streamable)
        self.loved = try container.decode(Bool.self, forKey: .loved)

        self.image = try container.decode(LastFMImages.self, forKey: .image)

        if let attrContainer = try? container.nestedContainer(keyedBy: CodingKeys.AttrKeys.self, forKey: .attr) {
            self.nowPlaying = try attrContainer.decode(
                Bool.self,
                forKey: .nowplaying
            )
        } else {
            self.nowPlaying = false
        }

        if let dateContainer = try? container.nestedContainer(
            keyedBy: CodingKeys.DateKeys.self,
            forKey: CodingKeys.date
        ) {
            let uts = try dateContainer.decode(
                Int.self,
                forKey: CodingKeys.DateKeys.uts
            )

            self.date = Date(timeIntervalSince1970: Double(uts))
        } else {
            self.date = nil
        }
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(artist, forKey: .artist)
        try container.encode(album, forKey: .album)
        try container.encode(mbid, forKey: .mbid)
        try container.encode(url, forKey: .url)
        try container.encode(image, forKey: .image)
        try container.encode(streamable ? "1" : "0", forKey: .streamable)
        try container.encode(loved ? "1" : "0", forKey: .loved)
        
        if let date = date {
            var dateContainer = container.nestedContainer(
                keyedBy: CodingKeys.DateKeys.self,
                forKey: .date)
            
            let timestamp = Int(date.timeIntervalSince1970)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM yyyy, HH:mm"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
                
            let dateText = formatter.string(from: date)
            
            try dateContainer.encode(String(timestamp), forKey: .uts)
            try dateContainer.encode(dateText, forKey: .text)
        } else {
            var attrContainer = container.nestedContainer(
                keyedBy: CodingKeys.AttrKeys.self,
                forKey: .attr)
            
            try attrContainer.encode(nowPlaying ? "true" : "false", forKey: .nowplaying)
        }
    }

}
