import UIKit
import Kingfisher

struct ProfileImage: Codable {
    let small: String
}

final class ProfileImageService {
    static let shared = ProfileImageService()
    private init() {}
    
    private(set) var avatarURL: String?
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProvideDidChange")
    
    func fetchAvatarURL(into imageView: UIImageView) {
        let imageUrlPath = "https://images.unsplash.com/profile-1746629042662-867971c07cdbimage?ixlib=imgixjs-3.3.2&crop=faces&fit=crop&w=300&h=300"
        
        guard let imageURL = URL(string: imageUrlPath) else {
            print("Неверная ссылка на аватарку")
            return
        }
        
        DispatchQueue.main.async {
            let processor = RoundCornerImageProcessor(cornerRadius: 100)
            imageView.kf.setImage(with: imageURL, placeholder: UIImage(named: "placeholder.jpeg"), options: [.processor(processor)])
        }
    }
    
    func fetchProfileImageURL(username: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let token = OAuth2TokenStorage.shared.token else {
            let error = NSError(domain: "TokenError", code: 401, userInfo: nil)
            print("Token error - \(error.localizedDescription)")
            completion(.failure(error))
            return
        }
        
        let urlString = "https://api.github.com/users/\(username)"
        
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "URLError", code: 400, userInfo: nil)
            print("URL error - \(error.localizedDescription)")
            completion(.failure(error))
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let userResult):
                    self?.avatarURL = userResult.profileImage.small
                    completion(.success(userResult.profileImage.small))
                    NotificationCenter.default.post(name: ProfileImageService.didChangeNotification, object: self)
                case .failure(let error):
                    print("Failed to fetch profile image URL: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
}
