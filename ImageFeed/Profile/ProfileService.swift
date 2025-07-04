import UIKit

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
        
        func clearProfile() {
            profile = nil
        }
    
    func createGETRequest(url: URL, bearerToken: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        guard let url = URL(string: "https://api.unsplash.com/me") else {
            let error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
            print("Invalid URL - \(error.localizedDescription)")
            completion(.failure(error))
            return
        }
        
        let request = createGETRequest(url: url, bearerToken: token)
        
        URLSession.shared.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let profileResult):
                    let profile = Profile(username: profileResult.username,
                                          firstName: profileResult.firstName ?? "",
                                          lastName: profileResult.lastName ?? "",
                                          bio: profileResult.bio ?? "")
                    
                    self?.profile = profile
                    
                    completion(.success(profile))
                    
                    print("нужные мне данные: \(profile)")
                    
                case .failure(let error):
                    print("Ошибка запроса профиля: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}

