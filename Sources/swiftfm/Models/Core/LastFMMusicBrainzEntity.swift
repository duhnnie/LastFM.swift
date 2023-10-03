import Foundation

public struct LastFMMusicBrainzEntity: URLNamed, MusicBrainz {
    public let name: String
    public let mbid: String
    public let url: URL

    public init(name: String, mbid: String, url: URL) {
        self.name = name
        self.mbid = mbid
        self.url = url
    }
}
