import Foundation

public struct LibraryArtist: Decodable {

    public let mbid: String
    public let name: String
    public let image: LastFMImages
    public let url: URL
    public let playcount: UInt
    public let streamable: Bool
    public let tagcount: UInt

}
