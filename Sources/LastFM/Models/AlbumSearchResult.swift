import Foundation

public struct AlbumSearchResult: Decodable {

    public let name: String
    public let artist: String
    public let url: URL
    public let image: LastFMImages
    public let streamable: Bool
    public let mbid: String

}
