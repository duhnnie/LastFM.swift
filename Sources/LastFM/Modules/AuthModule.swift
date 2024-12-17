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
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getSession(token: String) async throws -> ServiceSession {
        var params = parent.normalizeParams(
            params: ["token": token],
            method: APIMethod.getSession
        )

        try parent.addSignature(params: &params)
        
        return try await requester.getDataAndParse(params: params, type: ServiceSession.self, secure: true)
    }

    public func getSession(token: String, onCompletion: @escaping LastFM.OnCompletion<ServiceSession>) throws {
        var params = parent.normalizeParams(
            params: ["token": token],
            method: APIMethod.getSession
        )

        try parent.addSignature(params: &params)

        requester.getDataAndParse(params: params, secure: true, onCompletion: onCompletion)
    }
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getToken() async throws -> String {
        return try await withCheckedThrowingContinuation({ continuation in
            do {
                try self.getToken { result in
                    switch(result) {
                    case .success(let token):
                        continuation.resume(returning: token)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            } catch {
                continuation.resume(throwing: error)
            }
        })
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
    
    @available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    @available(*, deprecated, message: "Last.FM: This method has other parameters which are now deprecated and should not be used.")
    public func getMobileSession(username: String, password: String) async throws -> ServiceSession {
        return try await withCheckedThrowingContinuation({ continuation in
            do {
                try self.getMobileSession(username: username, password: password) { result in
                    switch (result) {
                    case .success(let serviceSession):
                        continuation.resume(returning: serviceSession)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            } catch {
                continuation.resume(throwing: error)
            }
        })
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
