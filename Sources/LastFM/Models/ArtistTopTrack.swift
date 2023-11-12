import Foundation

public struct ArtistTopTrack: Decodable {

    public let mbid: String?
    public let name: String
    public let artist: LastFMOptionalMBEntity
    public let images: LastFMImages
    public let url: URL
    public let streamable: Bool
    public let playcount: UInt
    public let listeners: UInt
    public let rank: UInt

    private enum CodingKeys: String, CodingKey {
        case mbid
        case name
        case artist
        case images = "image"
        case url
        case streamable
        case playcount
        case listeners
        case rank = "@attr"
    }
    
}
