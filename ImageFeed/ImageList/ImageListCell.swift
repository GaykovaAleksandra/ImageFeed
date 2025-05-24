import UIKit
import Kingfisher

protocol ImageListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImageListCell)
}

final class ImageListCell: UITableViewCell {
    static let reuseIdentifier = "ImageListCell"
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    
    private var isLiked: Bool = false {
            didSet {
                updateLikeButton()
            }
        }
    
    weak var delegate: ImageListCellDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImageView.kf.cancelDownloadTask()
        cellImageView.image = UIImage(named: "placeholder_photo")
    }
    
    @IBAction private func likeButtonClicked() {
        print("Like button tapped")
        isLiked.toggle()
        print("isLiked now: \(isLiked)")
        delegate?.imageListCellDidTapLike(self)
    }
    
    func setIsLiked(_ liked: Bool) {
            isLiked = liked
        }
    
    private func updateLikeButton() {
            let likeImage = isLiked ? UIImage(named: "Active") : UIImage(named: "No Active")
            likeButton.setImage(likeImage, for: .normal)
        }
}
