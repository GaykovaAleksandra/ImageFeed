import Foundation

 protocol ImageListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var dateFormatter: DateFormatter { get }
    
    func viewDidLoad()
//    func imageListCellDidTapLike(_ cell: ImageListCell)
}

final class ImageListPresenter: ImageListPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    
    private let imagesListService = ImagesListService.shared
    private let showSingleShowImageSegueIdentifier = "ShowSingleImage"
    
    private var photos: [Photo] = []
    private var photoViewModels: [PhotoViewModel] = []
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
//    func updateTableViewAnimated() {
//        let oldCount = photos.count
//        let newCount = imagesListService.photos.count
//        
//        if oldCount != newCount {
//            photos = imagesListService.photos
//            DispatchQueue.main.async { [weak self] in
//                self?.view?.tableView.performBatchUpdates {
//                    let indexPaths = (oldCount..<newCount).map { i in
//                        IndexPath(row: i, section: 0)
//                    }
//                    self?.view?.tableView.insertRows(at: indexPaths, with: .automatic)
//                } completion: { _ in }
//            }
//        }
//    }
    
    func viewDidLoad() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTable),
                                               name: ImagesListService.didChangeNotification,
                                               object: nil)
        
        imagesListService.fetchPhotosNextPage()
    }
    
    @objc private func updateTable() {
        view?.updateTableViewAnimated()
    }
    
//    func imageListCellDidTapLike(_ cell: ImageListCell) {
//        guard let indexPath = view?.tableView.indexPath(for: cell) else { return }
//        
//        let photo = photos[indexPath.row]
//        
//        UIBlockingProgressHUD.show()
//        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
//            
//            guard let self else { return }
//            
//            DispatchQueue.main.async {
//                switch result {
//                case .success:
//                    self.photos = self.imagesListService.photos
//                    UIBlockingProgressHUD.dismiss()
//                case .failure (let error):
//                    UIBlockingProgressHUD.dismiss()
//                    print("Ошибка при изменении лайка:", error)
//                    
//                    self.view?.showAlert()
//                }
//            }
//        }
//    
//        let newIsLiked = !photo.isLiked
//        photos[indexPath.row].isLiked = newIsLiked
//        
//        cell.setIsLiked(newIsLiked)
//    }
}
