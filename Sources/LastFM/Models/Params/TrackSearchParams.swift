import Foundation

public struct TrackSearchParams: Params {

    public var track: String
    public var artist: String?
    public var page: UInt
    public var limit: UInt

    public init(track: String, artist: String? = nil, page: UInt = 1, limit: UInt = 30) {
        self.track = track
        self.artist = artist
        self.page = page
        self.limit = limit
    }

    public func toDictionary() -> Dictionary<String, String> {
        var dict = [
            "track": self.track,
            "page": String(self.page),
            "limit": String(self.limit)
        ]

        if let artist = artist {
            dict["artist"] = artist
        }

        return dict
    }

}
