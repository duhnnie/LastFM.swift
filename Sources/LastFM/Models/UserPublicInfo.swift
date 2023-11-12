import Foundation

public struct UserPublicInfo: Decodable {

    public let name: String
    public let url: URL
    public let country: String
    public let playlists: UInt
    public let playcount: UInt
    public let image: LastFMImages
    public let registered: Date
    public let realname: String
    public let subscriber: Bool
    public let bootstrap: Bool
    public let type: String

}
