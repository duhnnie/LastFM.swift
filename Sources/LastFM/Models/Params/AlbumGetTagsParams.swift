import Foundation

public struct AlbumGetTagsParams: Params {

    public var artist: String
    public var album: String
    public var autocorrect: Bool
    public var user: String?

    public init(artist: String, album: String, autocorrect: Bool = true, user: String? = nil) {
        self.artist = artist
        self.album = album
        self.autocorrect = autocorrect
        self.user = user
    }

    internal func toDictionary() -> Dictionary<String, String> {
        var dict = [
            "artist": self.artist,
            "album": self.album,
            "autocorrect": self.autocorrect ? "1" : "0"
        ]

        if let user = user {
            dict["user"] = user
        }

        return dict
    }

}
