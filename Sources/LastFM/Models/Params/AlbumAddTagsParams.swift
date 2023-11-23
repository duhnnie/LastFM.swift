import Foundation

public struct AlbumAddTagsParams: Params {

    public var artist: String
    public var album: String
    public var tags: [String]

    public init(artist: String, album: String, tags: [String]) {
        self.artist = artist
        self.album = album
        self.tags = tags
    }

    internal func toDictionary() -> Dictionary<String, String> {
        return [
            "artist": self.artist,
            "album": self.album,
            "tags": self.tags.joined(separator: ",")
        ]
    }

}
