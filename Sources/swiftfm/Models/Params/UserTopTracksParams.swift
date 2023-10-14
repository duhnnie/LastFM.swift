import Foundation

public struct UserTopTracksParams {
    public var user: String
    public var period: Period
    public var limit: UInt
    public var page: UInt

    public enum Period: String {
        case overall
        case last7Days = "7day"
        case last30days = "1month"
        case last90days = "3month"
        case last180days = "6month"
        case lastYear = "12month"
    }

    public init(
        user: String,
        period: Period = .overall,
        limit: UInt = 50,
        page: UInt = 1
    ) {
        self.user = user
        self.period = period
        self.limit = limit
        self.page = page
    }
}
