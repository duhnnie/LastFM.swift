import Foundation

public struct UserWeeklyTrackChartParams: Params {

    public var user: String
    public var from: UInt
    public var to: UInt

    public init(user: String, from: UInt, to: UInt) {
        self.user = user
        self.from = from
        self.to = to
    }

    internal func toDictionary() -> Dictionary<String, String> {
        return [
            "user": user,
            "from": String(from),
            "to": String(to)
        ]
    }
    
}
