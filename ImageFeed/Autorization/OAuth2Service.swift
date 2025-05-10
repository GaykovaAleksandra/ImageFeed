import UIKit

enum AuthServiceError: Error {
    case invalideRequest
}

final class OAuth2Service {
    static let shared = OAuth2Service() 
    private init() {}
    
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard let baseURL = URL(string: "https://unsplash.com") else {
            print("Ошибка: не удалось создать baseURL")
            return nil
        }
        
        var urlComponents = URLComponents()
        urlComponents.path = "/oauth/token"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents.url(relativeTo: baseURL) else {
            print("Ошибка: не удалось создать URL из компонентов: \(urlComponents)")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        return request
    }
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        guard lastCode != code else {
            completion(.failure(AuthServiceError.invalideRequest))
            return
        }
        
        task?.cancel()
        lastCode = code
        
        guard let request = makeOAuthTokenRequest(code: code) else {
            completion(.failure(AuthServiceError.invalideRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let decoded):
                    let token = decoded.accessToken
                    OAuth2TokenStorage.shared.token = token
                    completion(.success(token))
                    
                case .failure(let error):
                    if let networkError = error as? NetworkError {
                        switch networkError {
                        case .httpStatusCode(let code, let data):
                            print("Ошибка: сервер вернул статус-код \(code)")
                            if let data = data, let errorString = String(data: data, encoding: .utf8) {
                                print("Ответ сервера: \(errorString)")
                            } else {
                                print("Ответ сервера пустой или не удалось декодировать")
                            }
                        case .urlRequestError(let requestError):
                            print("Ошибка запроса: \(requestError)")
                        case .urlSessionError:
                            print("Неизвестная ошибка URLSession")
                        }
                    } else {
                        print("Неизвестная ошибка сети: \(error)")
                    }
                    completion(.failure(error))
                }
                self?.task = nil
                self?.lastCode = nil
            }
        }
        self.task = task
        task.resume()
    }
}
