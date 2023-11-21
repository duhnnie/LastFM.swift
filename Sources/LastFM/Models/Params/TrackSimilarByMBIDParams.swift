import Foundation

public struct TrackSimilarByMBIDParams: Params {

    public var mbid: String
    public var autocorrect: Bool
    public var limit: UInt

    public init(mbid: String, autocorrect: Bool = true, limit: UInt = 10) {
        self.mbid = mbid
        self.autocorrect = autocorrect
        self.limit = limit
    }

    internal func toDictionary() -> Dictionary<String, String> {
        return [
            "mbid": mbid,
            "autocorrect": autocorrect ? "1" : "0",
            "limit": String(limit)
        ]
    }

}
