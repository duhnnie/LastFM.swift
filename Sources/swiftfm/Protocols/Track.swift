import Foundation

public protocol Track: Named {
    associatedtype Artist: MusicBrainz

    var name: String { get }
    var artist: Artist { get }
}
