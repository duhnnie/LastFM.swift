import Foundation

public struct ChartTopArtist: Decodable {

    public let mbid: String
    public let name: String
    public let image: LastFMImages
    public let url: URL
    public let listeners: UInt
    public let playcount: UInt
    public let streamable: Bool

}
