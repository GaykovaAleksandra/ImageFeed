import UIKit
import SwiftKeychainWrapper

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

// MARK: - AuthViewController

final class AuthViewController: UIViewController {
    
    // MARK: - Properties
    
    private let showWebViewSegueIdentifier = "ShowWebView"
    weak var delegate: AuthViewControllerDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(showWebViewSegueIdentifier)") }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - Private Methods
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .ypBlack
    }
    
    private func switchToSplashScreen() {
        let splashVC = SplashViewController()
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = splashVC
            window.makeKeyAndVisible()
        } else {
            present(splashVC, animated: true)
        }
    }
    
    func showErrorAlert() {
        let alert = UIAlertController(title: "Что-то пошло не так",
                                      message: "Не удалось войти в систему",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        
        present(alert, animated: true)
    }
}

// MARK: - WebViewViewControllerDelegate

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        navigationController?.popViewController(animated: true)
        
        UIBlockingProgressHUD.show()
        
        OAuth2Service.shared.fetchOAuthToken(code) { [weak self] result in
            
            DispatchQueue.main.async {
                
                guard let self else { return }
                
                UIBlockingProgressHUD.dismiss()
                
                switch result {
                case .success(let token):
                    print("Аутентификация успешна, токен получен: \(token)")
                    KeychainWrapper.standard.set(token, forKey: "oauthToken")
                    self.delegate?.authViewController(self, didAuthenticateWithCode: token)
                    self.switchToSplashScreen()
                case .failure(let error):
                    print("Ошибка аутентификации: \(error)")
                    self.showErrorAlert()
                }
            }
        }
    }
    
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
    
    func webViewViewController(_ vc: WebViewViewController, didFailWithError error: Error) {
        print("Ошибка загрузки WebView: \(error.localizedDescription)")
        showErrorAlert()
    }
}

