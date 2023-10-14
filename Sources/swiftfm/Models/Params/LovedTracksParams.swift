import Foundation

public struct LovedTracksParams {
    public var user: String
    public var limit: UInt
    public var page: UInt

    public init(user: String, limit: UInt, page: UInt) {
        self.user = user
        self.limit = limit
        self.page = page
    }
}
