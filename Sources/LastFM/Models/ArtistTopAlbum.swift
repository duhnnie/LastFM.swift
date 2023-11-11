import Foundation

public struct ArtistTopAlbum: Decodable {
    public let mbid: String
    public let name: String
    public let artist: LastFMMBEntity
    public let images: LastFMImages
    public let url: URL
    public let playcount: UInt

    private enum CodingKeys: String, CodingKey {
        case mbid
        case name
        case artist
        case images = "image"
        case url
        case playcount
    }

}
