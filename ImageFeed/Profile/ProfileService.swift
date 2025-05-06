import UIKit

struct ProfileResult: Codable {
    let username: String
    let firstName: String?
    let lastName: String?
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}

struct Profile {
    let username: String
    let firstName: String?
    let lastName: String?
    let bio: String?
    
    init(username: String, firstName: String, lastName: String, bio: String) {
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.bio = bio
    }
    
    var name: String {
        return "\(firstName ?? "") \(lastName ?? "")".trimmingCharacters(in: .whitespaces)
    }
    
    var loginName: String {
        return "@\(username)"
    }
}

final class ProfileService {
    static let shared = ProfileService()
    private init() {}
    
    private(set) var profile: Profile?
    
    func createGETRequest(url: URL, bearerToken: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        guard let url = URL(string: "https://api.unsplash.com/me") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        let request = createGETRequest(url: url, bearerToken: token)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                print("Ошибка запроса профиля: \(error)")
                completion(.failure(error))
                return
            }
            
            guard let data else {
                print("Нет данных в ответе")
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let profileResult = try JSONDecoder().decode(ProfileResult.self, from: data)
                
                let profile = Profile(username: profileResult.username,
                                      firstName: profileResult.firstName ?? "",
                                      lastName: profileResult.lastName ?? "",
                                      bio: profileResult.bio ?? "")
                
                self.profile = profile
                
                completion(.success(profile))
                
                print("нужные мне данные: \(profile)")
            } catch {
                print("Ошибка декодирования профиля: $error)")
                completion(.failure(error))
            }
        }.resume()
    }
}

