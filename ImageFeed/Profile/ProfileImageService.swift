import UIKit
import Kingfisher

struct ProfileImage: Codable {
    let large: String
}

final class ProfileImageService {
    static let shared = ProfileImageService()
    private init() {}
    
    private(set) var avatarURL: String?
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProvideDidChange")
    
    func fetchAvatarURL(into imageView: UIImageView) {
        guard let imageURLString = avatarURL, let imageURL = URL(string: imageURLString) else {
                print("Неверная ссылка на аватарку")
                return
            }
            
            let processor = RoundCornerImageProcessor(cornerRadius: 100)
            
        DispatchQueue.main.async {
            imageView.kf.setImage(with: imageURL,
                                  placeholder: UIImage(named: "placeholder.jpeg"),
                                  options: [.processor(processor)]) { result in
                switch result {
                case .success(let value):
                    print("Изображение успешно загружено: \(value.source.url?.absoluteString ?? "")")
                case .failure(let error):
                    print("Ошибка при загрузке изображения: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func fetchProfileImageURL(username: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let token = OAuth2TokenStorage.shared.token else {
            let error = NSError(domain: "TokenError", code: 401, userInfo: nil)
            print("Token error - \(error.localizedDescription)")
            completion(.failure(error))
            return
        }
        
        let urlString = "https://api.unsplash.com/users/\(username)"
        
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
                    self?.avatarURL = userResult.profileImage.large
                    completion(.success(userResult.profileImage.large))
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
