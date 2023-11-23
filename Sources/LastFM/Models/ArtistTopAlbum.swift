import Foundation

public struct ArtistTopAlbum: Decodable {

    public let mbid: String?
    public let name: String
    public let artist: LastFMOptionalMBEntity
    public let image: LastFMImages
    public let url: URL
    public let playcount: UInt

}
