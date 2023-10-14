import Foundation
import SwiftRestClient

internal struct RequestUtils: Requester {
    internal static let shared = RequestUtils()

    private let apiClient: APIClient

    internal init(apiClient: APIClient = SwiftRestClient.shared) {
        self.apiClient = apiClient
    }

    internal func build(params: [(String, String)] = [], secure: Bool) -> URL {
        var urlComponents = URLComponents(
            string: secure ? Constants.SECURE_API_HOST : Constants.INSECURE_API_HOST
        )!

        urlComponents.queryItems = params.map { URLQueryItem(name: $0.0, value: $0.1) }

        return urlComponents.url!
    }

    internal func makeGetRequest(
        url: URL,
        headers: SwiftRestClient.Headers?,
        onCompletion: @escaping (Result<Data, ServiceError>) -> Void
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

                    // TODO: remove forced unwrapping
                    let code = jsonDict!["code"] as! Int
                    let message = jsonDict!["message"] as! String

                    // TODO: remove forced unwrapping
                    let lastFMError = LastFMError(rawValue: code)!
                    onCompletion(.failure(ServiceError.LastFMError(lastFMError, message)))
                }
            } catch {
                onCompletion(.failure(.OtherError(error)))
            }
        }
    }

    internal func getDataAndParse<T: Decodable>(
        url: URL,
        headers: SwiftRestClient.Headers?,
        onCompletion: @escaping (Result<T, Error>) -> Void
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
                    onCompletion(.failure(error))
                }
            case .failure(let error):
                onCompletion(.failure(error))
            }
        }
    }
}
