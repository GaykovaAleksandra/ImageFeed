import UIKit
 
final class OAuth2Service {
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "https://unsplash.com/oauth/token") else {
            return
        }
 
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                    return
                }

                var updatedComponents = components
                updatedComponents.queryItems = [
                    .init(name: "client_id", value: Constants.accessKey),
                    .init(name: "client_secret", value: Constants.secretKey),
                    .init(name: "redirect_uri", value: Constants.redirectURI),
                    .init(name: "grant_type", value: "authorization_code"),
                    .init(name: "code", value: code),
                ]
        
        guard let requestURL = components.url else {
            return
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
 
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
 
            guard let data = data else {
                completion(.failure(NetworkError.urlSessionError))
                return
            }
 
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let accessToken = jsonResponse["access_token"] as? String
                {
                    completion(.success(accessToken))
                } else {
                    completion(.failure(NetworkError.urlSessionError))
                }
            } catch {
                completion(.failure(error))
            }
        }
 
        task.resume()
    }
}
