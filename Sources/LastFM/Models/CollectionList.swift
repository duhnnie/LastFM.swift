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

    public let items: [T]

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        guard let rootKey = container.allKeys.first else {
            throw RuntimeError("Error at getting root key.")
        }

        let subcontainer = try container.nestedContainer(
            keyedBy: CodingKeys.self,
            forKey: rootKey
        )

        var items: [T]?

        for key in subcontainer.allKeys {
            if key.stringValue != "@attr" {
                items = try subcontainer.decode([T].self, forKey: key)
            }
        }

        guard let items = items else {
            throw RuntimeError("Can't decode list")
        }

        self.items = items
    }
}

