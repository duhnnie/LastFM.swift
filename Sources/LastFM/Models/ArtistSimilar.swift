import Foundation

public struct ArtistSimilar: Decodable {

    public let mbid: String?
    public let name: String
    public let image: LastFMImages
    public let url: URL
    public let match: Float
    public let streamable: Bool

}
