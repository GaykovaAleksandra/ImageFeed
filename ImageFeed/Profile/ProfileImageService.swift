import UIKit

struct UserResult: Codable {
    let profileImage: ProfileImage
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct ProfileImage: Codable {
    let small: String
}

final class ProfileImageService {
    static let shared = ProfileImageService()
    private init() {}
    
    private(set) var avatarURL: String?
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProvideDidChange")
    
    func fetchProfileImageURL(username: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let token = OAuth2TokenStorage.shared.token else {
            completion(.failure(NSError(domain: "TokenError", code: 401, userInfo: nil)))
            return
        }
        
        let urlString = "https://api.github.com/users/\(username)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "URLError", code: 400, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error {
                completion(.failure(error))
                return
            }
            
            guard let data else {
                completion(.failure(NSError(domain: "DataError", code: 500, userInfo: nil)))
                return
            }
            
            do {
                let userResult = try JSONDecoder().decode(UserResult.self, from: data)
                self?.avatarURL = userResult.profileImage.small
                
                completion(.success(userResult.profileImage.small))
                
                NotificationCenter.default.post(
                    name: ProfileImageService.didChangeNotification,
                    object: self,
                    userInfo: ["URL": userResult.profileImage.small])
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
