import Foundation

public struct AlbumInfoByMBIDParams: Params {

    public var mbid: String
    public var autocorrect: Bool
    public var username: String?
    public var lang: String?

    public init(
        mbid: String,
        autocorrect: Bool = true,
        username: String? = nil,
        lang: String? = nil
    ) {
        self.mbid = mbid
        self.autocorrect = autocorrect
        self.username = username
        self.lang = lang
    }

    internal func toDictionary() -> Dictionary<String, String> {
        var dict = [
            "mbid": self.mbid,
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
