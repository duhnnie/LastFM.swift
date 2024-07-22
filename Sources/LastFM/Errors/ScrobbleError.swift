import Foundation

public enum ScrobbleError: Error {
    
    case TooMuchScrobbleIItems
    
}

extension ScrobbleError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .TooMuchScrobbleIItems:
            return NSLocalizedString("Too many items to scrobble, the maximum is 50.", comment: "")
        }
    }
    
}
