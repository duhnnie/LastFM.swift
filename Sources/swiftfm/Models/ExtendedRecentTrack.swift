import Foundation

public struct ExtendedRecentTrack: RecentTrackProtocol {
    private let recentTrack: RecentTrack<LastFMMusicBrainzWithImageEntity>

    public var name: String {
        recentTrack.name
    }

    public var artist: LastFMMusicBrainzWithImageEntity {
        recentTrack.artist
    }

    public var album: MusicBrainzEntity {
        recentTrack.album
    }

    public var mbid: String? {
        recentTrack.mbid
    }

    public var url: URL {
        recentTrack.url
    }

    public var images: LastFMImages? {
        recentTrack.images
    }

    public var date: Date? {
        recentTrack.date
    }

    public var nowPlaying: Bool {
        recentTrack.nowPlaying
    }

    public let loved: Bool

    private enum CodingKeys: String, CodingKey {
        case loved
    }

    public init(from decoder: Decoder) throws {
        let singleValueContainer = try decoder.singleValueContainer()
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.recentTrack = try singleValueContainer.decode(RecentTrack<LastFMMusicBrainzWithImageEntity>.self)

        let lovedString = try container.decode(String.self, forKey: .loved)
        self.loved = lovedString == "1"
    }
}
