import Foundation

public struct MBEntity: MBeable {
    
    public let name: String
    public let mbid: String

    enum CodingKeys: String, CodingKey {
        case name = "#text"
        case mbid = "mbid"
    }

}
