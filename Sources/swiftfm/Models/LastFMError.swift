//
//  File.swift
//  
//
//  Created by Daniel on 9/07/23.
//

import Foundation

enum LastFMError: Int, Error {
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
    case TemporaryProcessingError = 16
    case SuspendedAPIKey = 26
    case RateLimitExceeded = 29
}

enum ServiceError: Error {
    case LastFMError(LastFMError, String)
    case NoSessionKey
    case NoData
    case OtherError(Error)

    var detail: String {
        get {
            var detail = ""

            switch (self) {
            case .LastFMError(_, let message):
                detail = "\(message)"
            case .NoSessionKey:
                detail = "No session key."
            case .NoData:
                detail = "No data was returned."
            case .OtherError(let error):
                detail = "\(error.localizedDescription)"
            }

            return "Error: \(detail)"
        }
    }
}
