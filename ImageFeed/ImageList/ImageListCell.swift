import UIKit

final class ImageListCell: UITableViewCell {
    static let reuseIdentifier = "ImageListCell"
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
}
