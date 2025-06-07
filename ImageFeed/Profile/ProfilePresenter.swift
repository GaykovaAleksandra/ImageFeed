import Foundation

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    
    func updateProfile()
    func didTapLogout()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol?
    
    private let profileService = ProfileService.shared
    private let profileLogout = ProfileLogoutService.shared
    
    init(view: ProfileViewControllerProtocol) {
        self.view = view
    }
    
    func updateProfile() {
        
        if let profile = profileService.profile {
            view?.updateProfileDetails(profile: profile)
        } else {
            print("Профиль ещё не загружен")
        }
        
        view?.updateAvatar()
    }
    
    func didTapLogout() {
        profileLogout.logout()
        view?.showSplashScreen()
    }
    
}
