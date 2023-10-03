import Foundation

public struct RecentTracksParams {
    let user: String
    let limit: UInt
    let page: UInt
    let from: UInt?
    let to: UInt?

    public init(user: String, limit: UInt = 50, page: UInt = 1, from: UInt? = nil, to: UInt? = nil) {
        self.user = user
        self.limit = limit
        self.page = page
        self.from = from
        self.to = to
    }
}
