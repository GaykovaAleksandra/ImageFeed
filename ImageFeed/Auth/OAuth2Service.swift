import UIKit

final class OAuth2Service {
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "https://unsplash.com/oauth/token") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let bodyParameters = [
            "client_id": Constants.accessKey,
            "client_secret": Constants.secretKey,
            "redirect_uri": Constants.redirectURI,
            "grant_type": "authorization_code",
            "code": code
        ]
        
        request.httpBody = bodyParameters.map { _ in "$$0.key = $$0.value" }.joined(separator: "&").data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
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
                   let accessToken = jsonResponse["access_token"] as? String {
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
