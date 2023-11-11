import Foundation

public struct ChartTopTrack: Decodable, Equatable {

    public let mbid: String
    public let name: String
    public let artist: LastFMMBEntity
    public let images: LastFMImages
    public let duration: UInt
    public let url: URL
    public let streamable: Streamable
    public let playcount: UInt
    public let listeners: UInt

    private enum CodingKeys: String, CodingKey {
        case mbid
        case name
        case artist
        case images = "image"
        case duration
        case url
        case streamable
        case playcount
        case listeners
    }

}
