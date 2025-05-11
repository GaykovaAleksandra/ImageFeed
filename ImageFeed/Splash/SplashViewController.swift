import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    private let logoImageView = UIImageView(image: UIImage(named: "splash_screen_logo"))
    
    private let oauth2Service = OAuth2Service.shared
    private let storage = OAuth2TokenStorage.shared
    private let profileService = ProfileService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        logo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = storage.token {
            fetchProfile(token)
            print("Token exists, fetching profile")
        } else {
            presentAuthViewController()
            print("Token is nil, showing authentication screen")
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure ("Invalid Configuration")
            return
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        
        DispatchQueue.main.async {
            window.rootViewController = tabBarController
        }
    }
    
    private func logo() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
        
        logoImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        logoImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    }
    
    private func presentAuthViewController() {
        let auth = AuthViewController()
        auth.delegate = self
        auth.modalPresentationStyle = .fullScreen
        
        present(auth, animated: true, completion: nil)
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
        
        UIBlockingProgressHUD.show()
        
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self else { return }
            
            defer { UIBlockingProgressHUD.dismiss() }
            
            switch result {
            case .success(let token):
                print("Токен получен: \(token)")
                
                self.storage.token = token
                self.fetchProfile(token)
                
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                }
                
            case .failure(let error):
                print("Ошибка получения токена: \(error)")
                break
            }
        }
    }
    
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        
        guard let token = storage.token else { return }
        
        fetchProfile(token)
    }
    
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self else { return }
            
            switch result {
            case .success(let profile):
                
                let username = profile.username
                
                ProfileImageService.shared.fetchProfileImageURL(username: username) { _ in
                    // TODO - Не дожидаемся завершения запроса 
                }
                
                self.switchToTabBarController()
                
            case .failure:
                // TODO - обработка ошибки при получении профиля
                break
            }
        }
    }
}

