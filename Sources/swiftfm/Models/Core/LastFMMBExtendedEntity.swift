import Foundation

public struct LastFMMBExtendedEntity: MBeable {
    public let name: String
    public let mbid: String
    public let url: URL
    public let images: LastFMImages

    enum CodingKeys: String, CodingKey {
        case name
        case mbid
        case url
        case images = "image"
    }
}
