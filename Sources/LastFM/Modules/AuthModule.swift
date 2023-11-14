import Foundation
import SwiftRestClient

public struct AuthModule {

    internal enum APIMethod: String, MethodKey {
        case getSession = "getsession"

        func getName() -> String {
            return "auth.\(self.rawValue)"
        }
    }

    private let instance: LastFM
    private let requester: Requester

    internal init(instance: LastFM, requester: Requester = RequestUtils.shared) {
        self.instance = instance
        self.requester = requester
    }

    public func getSession(token: String, onCompletion: @escaping LastFM.OnCompletion<ServiceSession>) throws {
        var params = instance.normalizeParams(
            params: ["token": token],
            method: APIMethod.getSession
        )

        try instance.addSignature(params: &params)

        requester.getDataAndParse(params: params, secure: false, onCompletion: onCompletion)
    }
    
}
