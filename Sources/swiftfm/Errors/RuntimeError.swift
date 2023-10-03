import Foundation

public struct RuntimeError: LocalizedError {
    private let description: String

    internal init(_ description: String) {
        self.description = description
    }

    public var errorDescription: String? {
        description
    }
}
