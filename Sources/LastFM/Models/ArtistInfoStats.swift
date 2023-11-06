import Foundation

public struct ArtistInfoStats: Decodable {

    public let listeners: Int
    public let playcount: Int
    public let userPlaycount: Int?

    private enum CodingKeys: String, CodingKey {
        case listeners
        case playcount
        case userPlaycount = "userplaycount"
    }

}
