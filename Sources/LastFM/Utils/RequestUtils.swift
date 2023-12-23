import Foundation
import SwiftRestClient

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

internal struct RequestUtils: Requester {

    internal static let shared = RequestUtils()
    internal static let allowedURLQueryCharacters: CharacterSet = {
        var allowedCharacters = CharacterSet.urlQueryAllowed

        allowedCharacters.remove("+")
        allowedCharacters.remove("/")
        allowedCharacters.remove("?")
        allowedCharacters.remove("&")
        allowedCharacters.remove("=")
        allowedCharacters.remove("*")

        return allowedCharacters
    }()

    private static func urlEncode(_ string: String) throws -> String {
        guard let string = string.addingPercentEncoding(
            withAllowedCharacters: Self.allowedURLQueryCharacters
        ) else {
            throw RuntimeError("Can't encode string")
        }

        return string
    }

    private let apiClient: APIClient

    internal init(apiClient: APIClient = SwiftRestClient.shared) {
        self.apiClient = apiClient
    }

    private static func build(params: [String : String], secure: Bool) -> URL {
        var urlComponents = URLComponents(
            string: secure ? LastFM.SECURE_API_HOST : LastFM.INSECURE_API_HOST
        )!

        urlComponents.queryItems = params.map({ (key: String, value: String) in
            return URLQueryItem(name: key, value: value)
        })

        return urlComponents.url!
    }

    private static func buildForFormURLEncoded(
        payload: [String: String]
    ) throws -> (body: Data, headers: [String: String]) {
        guard
            let encodedFields = try? payload.map({ (key, value) -> String in
                return try "\(Self.urlEncode(key))=\(Self.urlEncode(value))"
            }),
            let body = encodedFields.joined(separator: "&").data(using: .utf8)
        else {
            throw RuntimeError("Can't encode fields.")
        }

        let headers = ["Content-Type": "application/x-www-formurlencoded"]

        return ( body: body, headers: headers )
    }

    private static func handleResponse(
        _ onCompletion: @escaping LastFM.OnCompletion<Data>
    ) -> (Data?, URLResponse?, Error?) -> Void {
        return { (data: Data?, response: URLResponse?, error: Error?) in
            guard error == nil else {
                onCompletion(.failure(.OtherError(error!)))
                return
            }

            guard let data = data else {
                onCompletion(.failure(.NoData))
                return
            }

            do {
                if
                    let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 200
                {
                    onCompletion(.success(data))
                } else {
                    let jsonDict = try JSONSerialization.jsonObject(
                        with: data,
                        options: []
                    ) as? [String: Any]

                    guard
                        let json = jsonDict,
                        let code = json["error"] as? Int,
                        let message = json["message"] as? String,
                        let lastfmErrorType = LastFMServiceErrorType(rawValue: code)
                    else {
                        onCompletion(.failure(.OtherError(RuntimeError("Unknown response"))))
                        return
                    }

                    onCompletion(.failure(.LastFMServiceError(lastfmErrorType, message)))
                }
            } catch {
                onCompletion(.failure(.OtherError(error)))
            }
        }
    }

    private static func handleEntityDecoding<T: Decodable>(
        _ onCompletion: @escaping LastFM.OnCompletion<T>
    ) -> (LastFM.OnCompletion<Data>) {
        return { result in
            switch (result) {
            case .success(let data):
                do {
                    let entity = try JSONDecoder().decode(
                        T.self,
                        from: data
                    )

                    onCompletion(.success(entity))
                } catch{
                    onCompletion(.failure(.OtherError(error)))
                }
            case .failure(let error):
                onCompletion(.failure(error))
            }
        }
    }

    internal func getDataAndParse<T: Decodable>(
        params: [String: String],
        secure: Bool = false,
        onCompletion: @escaping LastFM.OnCompletion<T>
    ) {
        var params = params
        params["format"] =  "json"

        let url = Self.build(params: params, secure: secure)
        let onDataReady = Self.handleEntityDecoding(onCompletion)
        let onRequestCompletion = Self.handleResponse(onDataReady)

        apiClient.get(url, headers: nil, onCompletion: onRequestCompletion)
    }

    internal func postFormURLEncodedAndParse<T: Decodable>(
        payload: [String: String],
        secure: Bool,
        onCompletion: @escaping LastFM.OnCompletion<T>
    ) throws {
        guard let headerAndBody = try? Self.buildForFormURLEncoded(payload: payload) else {
            throw RuntimeError("Error at building payload body.")
        }

        let body = headerAndBody.body
        let headers = headerAndBody.headers
        let url = Self.build(params: ["format": "json"], secure: secure)
        let onDataReady = Self.handleEntityDecoding(onCompletion)
        let onRequestCompletion = Self.handleResponse(onDataReady)

        apiClient.post(url, body: body, headers: headers, onCompletion: onRequestCompletion)
    }

    internal func postFormURLEncoded(
        payload: [String: String],
        secure: Bool,
        onCompletion: @escaping (LastFMError?) -> Void
    ) throws {
        guard let headerAndBody = try? Self.buildForFormURLEncoded(payload: payload) else {
            throw RuntimeError("Error at building payload body.")
        }

        let body = headerAndBody.body
        let headers = headerAndBody.headers
        let url = Self.build(params: ["format": "json"], secure: secure)

        let onRequestCompletion = Self.handleResponse { result in
            switch(result) {
            case .success(_):
                onCompletion(nil)
            case .failure(let error):
                onCompletion(error)
            }
        }

        apiClient.post(url, body: body, headers: headers, onCompletion: onRequestCompletion)
    }

}
