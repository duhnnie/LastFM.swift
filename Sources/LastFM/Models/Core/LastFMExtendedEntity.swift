import Foundation

public struct LastFMExtendedEntity: Nameable {

    public let name: String
    public let url: URL
    public let images: LastFMImages

    private enum CodingKeys: String, CodingKey {
        case name
        case url
        case images = "image"
    }
    
}
