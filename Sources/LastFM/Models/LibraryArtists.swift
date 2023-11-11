import Foundation

public struct LibraryArtist: Decodable {
    public let mbid: String
    public let name: String
    public let images: LastFMImages
    public let url: URL
    public let playcount: UInt
    public let streamable: Bool
    public let tagcount: UInt

    private enum CodingKeys: String, CodingKey {
        case mbid
        case name
        case images = "image"
        case url
        case playcount
        case streamable
        case tagcount
    }

}
