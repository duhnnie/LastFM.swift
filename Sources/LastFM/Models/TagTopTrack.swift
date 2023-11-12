import Foundation

public struct TagTopTrack: Decodable {

    public let mbid: String
    public let name: String
    public let artist: LastFMMBEntity
    public let images: LastFMImages
    public let url: URL
    public let duration: UInt
    public let streamable: Streamable
    public let rank: UInt

    public enum CodingKeys: String, CodingKey {
        case mbid
        case name
        case artist
        case images = "image"
        case url
        case duration
        case streamable
        case rank = "@attr"
    }
    
}
