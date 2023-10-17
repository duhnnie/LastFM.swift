import Foundation

public struct CollectionList<T: Decodable & Equatable>: Decodable, Equatable {
    struct CodingKeys: CodingKey {
        var stringValue: String

        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        var intValue: Int?

        init?(intValue: Int) {
            return nil
        }
    }

    enum InnerCodingKeys: String, CodingKey {
        case items = "track"
    }

    public let items: [T]

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        guard let rootKey = container.allKeys.first else {
            throw RuntimeError("Error at getting root key.")
        }

        let subcontainer = try container.nestedContainer(
            keyedBy: InnerCodingKeys.self,
            forKey: rootKey
        )

        self.items = try subcontainer.decode([T].self, forKey: .items)
    }
}

