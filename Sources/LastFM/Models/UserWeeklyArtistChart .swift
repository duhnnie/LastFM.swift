import Foundation

public struct UserWeeklyTrackChart: Decodable {

    public let mbid: String
    public let name: String
    public let url: URL
    public let artist: MBEntity
    public let image: LastFMImages
    public let playcount: UInt
    public let rank: UInt

    private enum CodingKeys: String, CodingKey {
        case mbid
        case name
        case url
        case artist
        case image
        case playcount
        case rank = "@attr"
    }

}
