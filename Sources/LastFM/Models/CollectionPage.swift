import Foundation

public struct CollectionPage<T: Decodable>: Decodable {

    public struct Pagination: Decodable {
        enum CodingKeys: String, CodingKey {
            case totalPages, page, perPage, total
        }

        public let totalPages: UInt
        public let page: UInt
        public let perPage: UInt
        public let total: UInt

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.totalPages = try container.decode(UInt.self, forKey: .totalPages)
            self.page = try container.decode(UInt.self, forKey: .page)
            self.perPage = try container.decode(UInt.self, forKey: .perPage)
            self.total = try container.decode(UInt.self, forKey: .total)
        }
    }

    enum InnerCodingKeys: String, CodingKey {
        case pagination = "@attr"
    }

    public let items: [T]
    public let pagination: Pagination

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKeys.self)

        guard let rootKey = container.allKeys.first else {
            throw RuntimeError("Error at getting root key.")
        }

        let subcontainer = try container.nestedContainer(
            keyedBy: StringCodingKeys.self,
            forKey: rootKey
        )

        var pagination: Pagination?
        var items: [T]?

        for key in subcontainer.allKeys {
            if key.stringValue == InnerCodingKeys.pagination.stringValue {
                pagination = try subcontainer.decode(Pagination.self, forKey: key)
            } else {
                items = try subcontainer.decode([T].self, forKey: key)
            }
        }

        guard
            let pagination = pagination,
            let items = items
        else {
            throw RuntimeError("Can't decode list")
        }

        self.pagination = pagination
        self.items = items
    }

}
