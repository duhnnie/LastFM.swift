import Foundation

public struct ArtistTagsParams: Params {

    public var artist: String
    public var autocorrect: Bool
    public var user: String?

    public init(artist: String, autocorrect: Bool = true, user: String? = nil) {
        self.artist = artist
        self.autocorrect = autocorrect
        self.user = user
    }

    public func toDictionary() -> Dictionary<String, String> {
        var dict = [
            "artist": self.artist,
            "autocorrect": self.autocorrect ? "1" : "0"
        ]

        if let user = user {
            dict["user"] = user
        }

        return dict
    }

}
