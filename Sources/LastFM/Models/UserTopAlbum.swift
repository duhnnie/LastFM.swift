import Foundation

public struct UserTopAlbum: Decodable {

    public let mbid: String
    public let name: String
    public let artist: LastFMMBEntity
    public let image: LastFMImages
    public let url: URL
    public let playcount: UInt
    public let rank: UInt

    private enum CodingKeys: String, CodingKey {
        case mbid
        case name
        case artist
        case image
        case url
        case playcount
        case rank = "@attr"
    }

}
