import Foundation
import SwiftRestClient

public struct AuthModule {

    internal enum APIMethod: String, MethodKey {
        case getSession = "getsession"
        case getToken = "gettoken"
        case getMobileSession = "getmobilesession"

        func getName() -> String {
            return "auth.\(self.rawValue)"
        }
    }

    private let parent: LastFM
    private let requester: Requester

    internal init(parent: LastFM, requester: Requester = RequestUtils.shared) {
        self.parent = parent
        self.requester = requester
    }

    public func getSession(token: String, onCompletion: @escaping LastFM.OnCompletion<ServiceSession>) throws {
        var params = parent.normalizeParams(
            params: ["token": token],
            method: APIMethod.getSession
        )

        try parent.addSignature(params: &params)

        requester.getDataAndParse(params: params, secure: true, onCompletion: onCompletion)
    }

    public func getToken(onCompletion: @escaping LastFM.OnCompletion<String>) throws {
        var params = parent.normalizeParams(params: [:], method: APIMethod.getToken)

        try parent.addSignature(params: &params)

        let internalOnCompletion: LastFM.OnCompletion<TokenResponse> = { result in
            switch (result) {
            case .success(let tokenResponse):
                onCompletion(.success(tokenResponse.token))
            case .failure(let error):
                onCompletion(.failure(error))
            }
        }

        requester.getDataAndParse(
            params: params,
            secure: true,
            onCompletion: internalOnCompletion
        )
    }

    @available(*, deprecated, message: "Last.FM: This method has other parameters which are now deprecated and should not be used.")
    public func getMobileSession(
        username: String,
        password: String,
        onCompletion: @escaping LastFM.OnCompletion<ServiceSession>
    ) throws {
        var params = parent.normalizeParams(
            params: ["username": username, "password": password],
            method: APIMethod.getMobileSession
        )

        try parent.addSignature(params: &params)

        try requester.postFormURLEncodedAndParse(
            payload: params,
            secure: true,
            onCompletion: onCompletion
        )
    }
    
}
