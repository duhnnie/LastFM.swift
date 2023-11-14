import Foundation

public struct ServiceSession: Decodable {

    public let name: String
    public let key: String
    public let subscriber: Bool

    private enum CodingKeys: String, CodingKey {
        case session

        enum SessionKeys: String, CodingKey {
            case name
            case key
            case subscriber
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let sessionContainer = try container.nestedContainer(
            keyedBy: CodingKeys.SessionKeys.self,
            forKey: .session
        )

        self.name = try sessionContainer.decode(String.self, forKey: .name)
        self.key = try sessionContainer.decode(String.self, forKey: .key)
        self.subscriber = try sessionContainer.decode(Bool.self, forKey: .subscriber)
    }

}
