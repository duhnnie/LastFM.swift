import Foundation

public struct ArtistGetInfoParams: Params {

    public var term: String
    public var lang: String?
    public var autocorrect: Bool
    public var username: String?
    public var criteria: TermCriteria

    public enum TermCriteria {
        case mbid
        case artist
    }

    public init(
        term: String,
        criteria: TermCriteria,
        lang: String? = nil,
        autocorrect: Bool = true,
        username: String? = nil
    ) {
        self.term = term
        self.criteria = criteria
        self.lang = lang
        self.autocorrect = autocorrect
        self.username = username
    }

    public func toDictionary() -> Dictionary<String, String> {
        var dict = [
            "autocorrect": self.autocorrect ? "1" : "0"
        ]

        switch(self.criteria) {
        case .mbid:
            dict["mbid"] = self.term
        case .artist:
            dict["artist"] = self.term
        }

        if let username = username {
            dict["username"] = username
        }

        if let lang = lang {
            dict["lang"] = lang
        }

        return dict
    }

}
