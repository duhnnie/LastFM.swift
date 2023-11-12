import Foundation

public struct TrackSearchResult: Decodable {

    public let name: String
    public let artist: String
    public let url: URL
    public let streamable: String
    public let listeners: UInt
    public let image: LastFMImages
    public let mbid: String

}
