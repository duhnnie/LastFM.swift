import Foundation

public struct TrackSimilar: Decodable {

    public let name: String
    public let mbid: String?
    public let match: Float
    public let url: URL
    public let streamable: Streamable
    public let duration: UInt
    public let artist: LastFMOptionalMBEntity
    public let image: LastFMImages
    public let playcount: UInt

}
