import Foundation

public struct AlbumInfoTrack: Decodable {

    public let name: String
    public let url: URL
    public let duration: UInt?
    public let trackNumber: UInt
    public let streamable: Streamable
    public let artist: LastFMMBEntity

    private enum CodingKeys: String, CodingKey {
        case name
        case url
        case duration
        case streamable
        case trackNumber = "@attr"
        case artist
    }

}
