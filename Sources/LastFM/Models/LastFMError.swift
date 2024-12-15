//
//  File.swift
//  
//
//  Created by Daniel on 9/07/23.
//

import Foundation

public enum LastFMServiceErrorType: Int {
    case InvalidService = 2
    case InvalidMethod = 3
    case AuthenticationFailed = 4
    case InvalidFormat = 5
    case InvalidParameters = 6
    case InvalidResourceSpecified = 7
    case OperationFailed = 8
    case InvalidSessionKey = 9
    case InvalidAPIKey = 10
    case ServiceOffline = 11
    case InvalidMethodSignature = 13
    case UnauthorizedTokn = 14
    case TemporaryProcessingError = 16
    case SuspendedAPIKey = 26
    case RateLimitExceeded = 29
}

public enum LastFMError: Error {
    case LastFMServiceError(LastFMServiceErrorType, String)
    case NoData
    case OtherError(Error)
}

extension LastFMError: LocalizedError {

    public var errorDescription: String? {
        var detail = ""

        switch (self) {
        case .LastFMServiceError(_, let message):
            detail = "\(message)"
        case .NoData:
            detail = "No data was returned."
        case .OtherError(let error):
            detail = "\(error.localizedDescription)"
        }

        return "Error: \(detail)"
    }

}
