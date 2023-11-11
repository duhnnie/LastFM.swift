import Foundation

protocol Nameable: Decodable {
    var name: String { get }
}
