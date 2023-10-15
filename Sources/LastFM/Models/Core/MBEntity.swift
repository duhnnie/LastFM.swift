import Foundation

public struct MBEntity: MBeable {
    public let name: String
    public let mbid: String

    enum CodingKeys: String, CodingKey {
        case name = "#text"
        case mbid = "mbid"
    }

    // TODO: remove this initializer when turning this struct into internal
//    public init(name: String, mbid: String) {
//        self.name = name
//        self.mbid = mbid
//    }
}
