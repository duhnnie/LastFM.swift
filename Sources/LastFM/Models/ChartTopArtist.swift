import Foundation

public struct ChartTopArtist: Decodable {

    public let mbid: String
    public let name: String
    public let images: LastFMImages
    public let url: URL
    public let listeners: UInt
    public let playcount: UInt
    public let streamable: Bool

    private enum CodingKeys: String, CodingKey {
        case mbid
        case name
        case images = "image"
        case url
        case listeners
        case playcount
        case streamable
    }

}
