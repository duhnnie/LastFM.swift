import Foundation

public struct UserWeeklyAlbumChart: Decodable {

    public let mbid: String
    public let name: String
    public let artist: MBEntity
    public let url: URL
    public let playcount: UInt
    public let rank: UInt

    private enum CodingKeys: String, CodingKey {
        case mbid
        case name
        case artist
        case url
        case playcount
        case rank = "@attr"
    }

}
