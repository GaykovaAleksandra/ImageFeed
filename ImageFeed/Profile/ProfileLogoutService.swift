import UIKit
import SwiftKeychainWrapper
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    
    private init() {}
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let imagesListService = ImagesListService.shared
    private let oauth = OAuth2TokenStorage.shared
    
    func logout() {
        cleanCookies()
        resetUserData()
        goToInitialScreen()
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    private func resetUserData() {
        profileService.clearProfile()
        profileImageService.clearProfileImage()
        imagesListService.clearImages()
        
        KeychainWrapper.standard.removeObject(forKey: oauth.tokenKey)
    }
    
    private func goToInitialScreen() {
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                guard let authVC = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {
                    return
                }
                
                authVC.modalPresentationStyle = .fullScreen
                
                window.rootViewController = authVC
                window.makeKeyAndVisible()
            }
        }
    }
}
