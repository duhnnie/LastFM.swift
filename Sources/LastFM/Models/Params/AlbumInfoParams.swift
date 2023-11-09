import Foundation

public struct AlbumInfoParams: Params {

    public var artist: String
    public var album: String
    public var autocorrect: Bool
    public var username: String?
    public var lang: String?

    public init(
        artist: String,
        album: String,
        autocorrect: Bool = true,
        username: String? = nil,
        lang: String? = nil
    ) {
        self.artist = artist
        self.album = album
        self.autocorrect = autocorrect
        self.username = username
        self.lang = lang
    }

    internal func toDictionary() -> Dictionary<String, String> {
        var dict = [
            "artist": self.artist,
            "album": self.album,
            "autocorrect": self.autocorrect ? "1" : "0"
        ]

        if let username = username {
            dict["username"] = username
        }

        if let lang = lang {
            dict["lang"] = lang
        }

        return dict
    }
    
}
