//
//  ImageListCell.swift
//  ImageFeed
//
//  Created by Александра Гайкова on 23.03.25.
//
import UIKit

final class ImageListCell: UITableViewCell {
    static let reuseIdentifier = "ImageListCell"
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    
    func configure(with image: UIImage?) {
        cellImageView.image = image
    }
}
