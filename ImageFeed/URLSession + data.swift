import UIKit

enum NetworkError: Error {
    case httpStatusCode(Int, Data?)
    case urlRequestError(Error)
    case urlSessionError
}

extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        
        let task = dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "DataError", code: -1,
                                            userInfo: [NSLocalizedDescriptionKey : "No data received"])))
                return
            }
            
            do {
                let object = try decoder.decode(T.self, from: data)
                completion(.success(object))
            } catch {
                completion(.failure(error))
            }
        }
        
        return task
    }
}
