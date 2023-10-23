import Foundation

public struct CollectionPage<T: Decodable & Equatable>: Decodable, Equatable {
    public struct Pagination: Codable, Equatable {
        enum CodingKeys: String, CodingKey {
            case totalPages, page, perPage, total
        }

        public let totalPages: Int
        public let page: Int
        public let perPage: Int
        public let total: Int

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            guard
                let totalPages = try? Int(container.decode(String.self, forKey: .totalPages)),
                let page = try? Int(container.decode(String.self, forKey: .page)),
                let perPage = try? Int(container.decode(String.self, forKey: .perPage)),
                let total = try? Int(container.decode(String.self, forKey: .total))
            else {
                throw RuntimeError("Error at decoding pagination members.")
            }

            self.totalPages = totalPages
            self.page = page
            self.perPage = perPage
            self.total = total
        }
    }

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
        case pagination = "@attr"
    }

    public let items: [T]
    public let pagination: Pagination

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        guard let rootKey = container.allKeys.first else {
            throw RuntimeError("Error at getting root key.")
        }

        let subcontainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: rootKey)
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
