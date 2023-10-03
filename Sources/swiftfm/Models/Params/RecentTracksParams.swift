import Foundation

public struct RecentTracksParams {
    public var user: String
    public var limit: UInt
    public var page: UInt
    public var from: UInt?
    public var to: UInt?

    public init(user: String, limit: UInt = 50, page: UInt = 1, from: UInt? = nil, to: UInt? = nil) {
        self.user = user
        self.limit = limit
        self.page = page
        self.from = from
        self.to = to
    }
}
