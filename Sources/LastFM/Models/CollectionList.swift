import Foundation

public struct CollectionList<T: Decodable>: Decodable {

    public let items: [T]

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKeys.self)

        guard let rootKey = container.allKeys.first else {
            let context = DecodingError.Context(
                codingPath: decoder.codingPath,
                debugDescription: "Error at getting root key."
            )

            throw DecodingError.dataCorrupted(context)
        }

        let subcontainer = try container.nestedContainer(
            keyedBy: StringCodingKeys.self,
            forKey: rootKey
        )

        var items: [T]?

        for key in subcontainer.allKeys {
            if key.stringValue != "@attr" {
                items = try subcontainer.decode([T].self, forKey: key)
            }
        }

        guard let items = items else {
            let context = DecodingError.Context(
                codingPath: subcontainer.codingPath,
                debugDescription: "Can't decode list"
            )

            throw DecodingError.dataCorrupted(context)
        }

        self.items = items
    }

}

