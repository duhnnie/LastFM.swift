import Foundation

internal struct Util {

    internal static func createResponse(
        url: URL = URL(string: "https://domain.dummy")!,
        statusCode: Int = 200
    ) -> HTTPURLResponse? {
        return HTTPURLResponse(
            url: url,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )
    }

    internal static func areSameURL(_ urlA: URL, _ urlB: URL) -> Bool {
        if !(urlA.scheme == urlB.scheme && urlA.host == urlB.host) {
            return false
        }

        let urlComponentsA = URLComponents(url: urlA, resolvingAgainstBaseURL: true)
        let urlComponentsB = URLComponents(url: urlB, resolvingAgainstBaseURL: true)

        guard
            let queryItemsA = urlComponentsA?.queryItems,
            let queryItemsB = urlComponentsB?.queryItems
        else {
            return false
        }

        return queryItemsA.count == queryItemsB.count && queryItemsA.allSatisfy({ urlQueryItem in
            return queryItemsB.contains(urlQueryItem)
        })
    }

    internal static func areSameURL(_ urlStringA: String, _ urlStringB: String) -> Bool {
        guard
            let urlA = URL(string: urlStringA),
            let urlB = URL(string: urlStringB)
        else {
            return false
        }

        return areSameURL(urlA, urlB)
    }
}
