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

        let task = data(for: request) { (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                do {
                    let object = try decoder.decode(T.self, from: data)
                    completion(.success(object))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        task.resume()
        return task
    }
}
