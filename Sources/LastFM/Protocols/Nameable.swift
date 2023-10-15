import Foundation

protocol Nameable: Decodable, Equatable {
    var name: String { get }
}
