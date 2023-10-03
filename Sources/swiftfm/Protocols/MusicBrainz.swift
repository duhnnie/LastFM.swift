import Foundation

public protocol MusicBrainz: Named {
    var mbid: String { get }
    var name: String { get }
}
