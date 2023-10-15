import Foundation
import SwiftRestClient

internal struct RequestUtils: Requester {
    internal static let shared = RequestUtils()

    private let apiClient: APIClient

    internal init(apiClient: APIClient = SwiftRestClient.shared) {
        self.apiClient = apiClient
    }

    internal func build(params: [String : String], secure: Bool) -> URL {
        var urlComponents = URLComponents(
            string: secure ? SwiftFM.SECURE_API_HOST : SwiftFM.INSECURE_API_HOST
        )!

        urlComponents.queryItems = params.map({ (key: String, value: String) in
            return URLQueryItem(name: key, value: value)
        })

        return urlComponents.url!
    }

    internal func makeGetRequest(
        url: URL,
        headers: SwiftRestClient.Headers?,
        onCompletion: @escaping SwiftFM.OnCompletion<Data>
    ) {
        apiClient.get(url, headers: headers) { data, response, error in
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
                    let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

                    guard
                        let json = jsonDict,
                        let code = json["error"] as? Int,
                        let message = json["message"] as? String,
                        let lastfmError = LastFMError(rawValue: code)
                    else {
                        onCompletion(.failure(.OtherError(RuntimeError("Unknown response"))))
                        return
                    }

                    onCompletion(.failure(.LastFMError(lastfmError, message)))
                }
            } catch {
                onCompletion(.failure(.OtherError(error)))
            }
        }
    }

    internal func getDataAndParse<T: Decodable>(
        url: URL,
        headers: SwiftRestClient.Headers?,
        onCompletion: @escaping SwiftFM.OnCompletion<T>
    ) {
        makeGetRequest(url: url, headers: headers) { result in
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
}
