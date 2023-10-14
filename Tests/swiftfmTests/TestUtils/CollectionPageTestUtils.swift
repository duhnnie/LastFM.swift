import Foundation

internal struct CollectionPageTestUtils {

    internal static func generateJSON(
        items: String,
        totalPages: String,
        page: String,
        perPage: String,
        total: String
    ) -> Data {
        return """
{
  "listname": {
    "track": \(items),
    "@attr": {
      "totalPages": "\(totalPages)",
      "page": "\(page)",
      "perPage": "\(perPage)",
      "total": "\(total)"
    }
  }
}
""".data(using: .utf8)!
    }
    
}
