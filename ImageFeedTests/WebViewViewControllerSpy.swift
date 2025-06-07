import ImageFeed
import Foundation

final class WebViewViewControllerSpy: WebViewControllerProtocol {
    var loadRequestCalled = false
    var presenter: WebViewPresenterProtocol?
    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
    }
    
    func setProgressHidden(_ isHidden: Bool) {
    }
    
    
}
