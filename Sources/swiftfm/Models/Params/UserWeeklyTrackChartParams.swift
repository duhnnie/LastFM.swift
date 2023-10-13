import Foundation

public struct UserWeeklyTrackChartParams {
    public var user: String
    public var from: UInt
    public var to: UInt

    public init(user: String, from: UInt, to: UInt) {
        self.user = user
        self.from = from
        self.to = to
    }
}
