import Foundation

public struct UserTopArtist: Decodable {
    
    public let mbid: String
    public let name: String
    public let image: LastFMImages
    public let url: URL
    public let playcount: UInt
    public let streamable: Bool
    public let rank: UInt

    private enum CodingKeys: String, CodingKey {
        case mbid
        case name
        case image
        case url
        case playcount
        case streamable
        case rank = "@attr"
    }

}
