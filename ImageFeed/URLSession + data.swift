import UIKit

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

extension URLSession {
    func data(
        for request: URLRequest,
        completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<(Data, HTTPURLResponse), Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request) { data, response, error in
            if let error = error {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
                return
            }
            
            guard let data = data else {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
                return
            }
            
            if (200..<300).contains(httpResponse.statusCode) {
                fulfillCompletionOnTheMainThread(.success((data, httpResponse)))
            } else {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(httpResponse.statusCode)))
            }
        }
        
        task.resume()
        return task
    }
}
