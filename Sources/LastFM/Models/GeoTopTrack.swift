import Foundation

public struct GeoTopTrack: Decodable {

    public let mbid: String
    public let name: String
    public let artist: LastFMMBEntity
    public let image: LastFMImages
    public let duration: UInt
    public let url: URL
    public let streamable: Streamable
    public let listeners: UInt
    public let rank: UInt

    private enum CodingKeys: String, CodingKey {
        case mbid
        case name
        case artist
        case image
        case duration
        case url
        case streamable
        case listeners
        case rank = "@attr"
    }

}
