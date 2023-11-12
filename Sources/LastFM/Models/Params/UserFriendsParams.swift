import Foundation

public struct UserFriendsParams: Params {

    public var user: String
    public var limit: UInt
    public var page: UInt

    public init(user: String, limit: UInt = 50, page: UInt = 1) {
        self.user = user
        self.limit = limit
        self.page = page
    }

    internal func toDictionary() -> Dictionary<String, String> {
        return [
            "user": user,
            "limit": String(limit),
            "page": String(page)
        ]
    }

}
