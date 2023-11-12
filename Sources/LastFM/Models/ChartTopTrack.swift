import Foundation

public struct ChartTopTrack: Decodable {

    public let mbid: String
    public let name: String
    public let artist: LastFMMBEntity
    public let image: LastFMImages
    public let duration: UInt
    public let url: URL
    public let streamable: Streamable
    public let playcount: UInt
    public let listeners: UInt

}
