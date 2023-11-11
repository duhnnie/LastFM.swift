import Foundation

public struct SearchResults<T: Decodable>: Decodable {

    public struct Pagination: Decodable {
        public let startPage: UInt
        public let totalResults: UInt
        public let startIndex: UInt
        public let itemsPerPage: UInt

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.NestedCodingKeys.self)

            let openQueryContainer = try container.nestedContainer(
                keyedBy: CodingKeys.NestedCodingKeys.OpenSearchKeys.self,
                forKey: .query
            )

            self.startPage = try openQueryContainer.decode(UInt.self, forKey: .startPage)
            self.totalResults = try container.decode(UInt.self, forKey: .totalResults)
            self.startIndex = try container.decode(UInt.self, forKey: .startIndex)
            self.itemsPerPage = try container.decode(UInt.self, forKey: .itemsPerPage)
        }
    }

    public let items: [T]
    public let pagination: Pagination

    private enum CodingKeys: String, CodingKey {
        case results

        enum NestedCodingKeys: String, CodingKey {
            case query = "opensearch:Query"
            case totalResults = "opensearch:totalResults"
            case startIndex = "opensearch:startIndex"
            case itemsPerPage = "opensearch:itemsPerPage"

            enum OpenSearchKeys: String, CodingKey {
                case startPage
            }
        }

    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let resultsContainer = try container.nestedContainer(
            keyedBy: StringCodingKeys.self,
            forKey: .results
        )

        self.pagination = try container.decode(Pagination.self, forKey: .results)

        guard let subcontainerKey = resultsContainer.allKeys.first(where: { key in
            return ![
                "opensearch:Query",
                "opensearch:totalResults",
                "opensearch:startIndex",
                "opensearch:itemsPerPage",
                "@attr"
            ].contains(key.stringValue)
        }) else {
            throw RuntimeError("Can't find key for subcontainer")
        }

        let subcontainer = try resultsContainer.nestedContainer(
            keyedBy: StringCodingKeys.self,
            forKey: subcontainerKey
        )

        guard let itemsKey = subcontainer.allKeys.first else {
            throw RuntimeError("Can't find key for items")
        }

        self.items = try subcontainer.decode([T].self, forKey: itemsKey)
    }

}
