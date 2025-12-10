import UIKit

public class EkycManager {
    
    public static let shared = EkycManager()
    
    private let baseURL = "https://www.youtube.com" 
    
    private init() {}
    
    public weak var delegate: EkycDelegate?
    
    public func startEkyc(config: EkycConfig, from viewController: UIViewController) {
        
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "userId", value: config.userId)
        ]
        
        guard let url = components?.url else {
            delegate?.ekycDidFail(error: NSError(domain: "EkycSdk", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL construction"]))
            return
        }
        
        let webVC = EkycWebViewController(url: url, themeColor: config.themeColor)
        webVC.delegate = delegate
        
        let nav = UINavigationController(rootViewController: webVC)
        nav.modalPresentationStyle = .fullScreen
        nav.navigationBar.tintColor = config.themeColor
        
        viewController.present(nav, animated: true, completion: nil)
    }
}
