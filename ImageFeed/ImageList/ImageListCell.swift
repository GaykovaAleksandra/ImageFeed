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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellImageView.kf.indicatorType = .activity
    }
    
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
    
    func configure(with imageURL: URL?, liked: Bool, dateText: String?) {
        setIsLiked(liked)
        
        if let url = imageURL {
            cellImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder_photo"))
        } else {
            cellImageView.image = UIImage(named: "placeholder_photo")
        }
        
        dateLabel.text = dateText
    }
    
    private func updateLikeButton() {
        let imageName = isLiked ? "Active" : "No Active"
        likeButton.setImage(UIImage(named: imageName), for: .normal)
    }
}
