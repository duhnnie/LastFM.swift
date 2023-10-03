import Foundation

public protocol RecentTrackProtocol: Track {
    var name: String { get }
    var artist: Artist { get }
    var album: MusicBrainzEntity { get }
    var mbid: String? { get }
    var url: URL { get }
    var images: LastFMImages? { get }
    var date: Date? { get }
    var nowPlaying: Bool { get }
}
