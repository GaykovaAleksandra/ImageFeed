import UIKit

final class ProfileViewController: UIViewController {
    
    //MARK: - IBOutlets

    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var loginNameLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var logoutButton: UIButton!
    
    //MARK: - IBAction

    @IBAction private func didTapLogoutButton() {
    }
}
