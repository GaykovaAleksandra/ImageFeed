import Foundation

struct PhotoViewModel {
    let id: String
    let thumbImageURL: String
    let largeImageURL: String
    let createdAtText: String
    let size: CGSize
    var isLiked: Bool
    
    init(photo: Photo, dateFormatter: DateFormatter) {
        self.id = photo.id
        self.thumbImageURL = photo.thumbImageURL
        self.largeImageURL = photo.largeImageURL
        self.size = photo.size
        self.isLiked = photo.isLiked
        
        if let date = photo.createdAt {
            self.createdAtText = dateFormatter.string(from: date)
        } else {
            self.createdAtText = ""
        }
    }
}
