import UIKit

final class SplashViewController: UIViewController {
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    
    private let oauth2Service = OAuth2Service()
    private let storage = OAuth2TokenStorage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = storage.token {
            switchToTabBarController()
            print("Token exists, switching to tab bar controller")
        } else {
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
            print("Token is nil, showing authentication screen")
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers.first as? AuthViewController
            else {
                assertionFailure("Failed to prepare for $showAuthenticationScreenSegueIdentifier)")
                return
            }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        oauth2Service.fetchOAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                print("Токен получен: \(token)")
                self.storage.token = token
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                }
            case .failure(let error):
                print("Ошибка получения токена: \(error)")
                break
            }
        }
    }
}
