import Foundation

public protocol Named: Decodable {
    var name: String { get }
}
