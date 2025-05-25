import UIKit
import SwiftKeychainWrapper

final class ProfileViewController: UIViewController {
    
    private let avatarImageView = UIImageView(image: UIImage(named: "Photo"))
    private let nameLabel = UILabel()
    private let loginNameLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    private let profileService = ProfileService.shared
    private let profileLogout = ProfileLogoutService.shared
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            self.updateAvatar()
        }
        
        DispatchQueue.main.async {
            if let profile = self.profileService.profile {
                self.updateProfileDetails(profile: profile)
            } else {
                print("Профиль еще не загружен")
            }
        }
        
        view.backgroundColor = .ypBlack
        
        avatarImage()
        name()
        loginName()
        description()
        
        logout()
        updateAvatar()
        
        ProfileImageService.shared.fetchAvatarURL(into: avatarImageView)
    }
    
    deinit {
        if let observer = profileImageServiceObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    private func updateProfileDetails(profile: Profile) {
        nameLabel.text = profile.name
        loginNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio ?? ""
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
    }
    
    private func avatarImage() {
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarImageView)
        
        avatarImageView.backgroundColor = .clear
        
        avatarImageView.layer.cornerRadius = 35
        avatarImageView.clipsToBounds = true
        
        avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    private func name() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        nameLabel.text = "Екатерина Новикова"
        nameLabel.font = .systemFont(ofSize: 23, weight: .bold)
        nameLabel.textColor = .ypWhite
        nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8).isActive = true
    }
    
    private func loginName() {
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
        
        loginNameLabel.text = "@ekaterina_nov"
        loginNameLabel.font = .systemFont(ofSize: 13, weight: .medium)
        loginNameLabel.textColor = .ypGrey
        loginNameLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
        loginNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    private func description() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        descriptionLabel.text = "Hello, World!"
        descriptionLabel.font = .systemFont(ofSize: 13, weight: .medium)
        descriptionLabel.textColor = .ypWhite
        descriptionLabel.trailingAnchor.constraint(equalTo: loginNameLabel.trailingAnchor, constant: 16).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: loginNameLabel.leadingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    private func logout() {
        let logoutButton = UIButton.systemButton(
            with: UIImage(named: "Exit")!,
            target: nil,
            action: #selector(Self.didTapLogoutButton)
        )
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        logoutButton.tintColor = .ypRed
        logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor).isActive = true
        logoutButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    @objc
    private func didTapLogoutButton() {
        
        let alert = UIAlertController(title: "Пока, пока!", message: "Уверены, что хотите выйти?", preferredStyle: .alert)
        
        let logoutAction = UIAlertAction(title: "Да", style: .destructive) { [weak self] _ in
            self?.profileLogout.logout()
        }
       
        let cancelAction = UIAlertAction(title: "Нет", style: .cancel)
        
        let buttonColor = UIColor.ypBlue
        
        logoutAction.setValue(buttonColor, forKey: "titleTextColor")
        cancelAction.setValue(buttonColor, forKey: "titleTextColor")
        
        alert.addAction(logoutAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}
