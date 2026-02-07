import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

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

    internal static func areSameQueries(
        _ queryItemsA: [URLQueryItem],
        _ queryItemsB: [URLQueryItem]
    ) -> Bool {
        return queryItemsA.count == queryItemsB.count && queryItemsA.allSatisfy({ urlQueryItem in
            return queryItemsB.contains(urlQueryItem)
        })
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

        return areSameQueries(queryItemsA, queryItemsB)
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
    
    private static func jsonEquals(_ lhs: Any, _ rhs: Any) -> Bool {
        switch (lhs, rhs) {

        case let (l as NSDictionary, r as NSDictionary):
            return l.count == r.count &&
                l.allKeys.allSatisfy { key in
                    guard let rValue = r[key] else { return false }
                    return jsonEquals(l[key]!, rValue)
                }

        case let (l as NSArray, r as NSArray):
            guard l.count == r.count else { return false }
            return zip(l, r).allSatisfy { jsonEquals($0, $1) }

        case let (l as NSNumber, r as NSNumber):
            return l == r

        case let (l as NSString, r as NSString):
            return l == r

        case (_ as NSNull, _ as NSNull):
            return true

        default:
            return false
        }
    }

    internal static func jsonDataEquals(_ lhs: Data, _ rhs: Data) -> Bool {
        do {
            let leftObject = try JSONSerialization.jsonObject(with: lhs, options: [.fragmentsAllowed])
            let rightObject = try JSONSerialization.jsonObject(with: rhs, options: [.fragmentsAllowed])
            
            return jsonEquals(leftObject, rightObject)
        } catch {
            return false
        }
    }

}
