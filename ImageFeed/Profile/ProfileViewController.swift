import UIKit

final class ProfileViewController: UIViewController {
    
    let avatarImageView = UIImageView(image: UIImage(named: "Photo"))
    let nameLabel = UILabel()
    let loginNameLabel = UILabel()
    let descriptionLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        title = "Profile"
        avatarImage()
        name()
        loginName()
        description()
        logout()
    }
    
    func avatarImage() {
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarImageView)
        
        avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    func name() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        nameLabel.text = "Екатерина Новикова"
        nameLabel.font = .systemFont(ofSize: 23, weight: .bold)
        nameLabel.textColor = .ypWhite
        nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8).isActive = true
    }
    
    func loginName() {
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
        
        loginNameLabel.text = "@ekaterina_nov"
        loginNameLabel.font = .systemFont(ofSize: 13, weight: .medium)
        loginNameLabel.textColor = .ypWhite
        loginNameLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
        loginNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    func description() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        descriptionLabel.text = "Hello, World!"
        descriptionLabel.font = .systemFont(ofSize: 13, weight: .medium)
        descriptionLabel.textColor = .ypGrey
        descriptionLabel.trailingAnchor.constraint(equalTo: loginNameLabel.trailingAnchor, constant: 16).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: loginNameLabel.leadingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    func logout() {
        let logoutButton = UIButton.systemButton(
            with: UIImage(named: "Exit")!,
            target: nil,
            action: #selector(Self.didTapLogoutButton)
        )
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor).isActive = true
        logoutButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    @objc
    private func didTapLogoutButton() {
    }
}
