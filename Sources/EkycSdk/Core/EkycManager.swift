import UIKit
import WebKit

 

public final class EkycManager {
    
    public static let shared = EkycManager()
    
      private let baseURLString = "https://verify.bantech.ae/?vid=%2Fapi%2Fa0913c4e10504651bbdaa826d8d84f71%2Ftest%2Fa091578e7343453b890448e42020cfbc%2Fweb%3Fexpires%3D1765464597%26signature%3D14d4b8a88901140a021248b4f682d600c32dcbc69eca4f837ab5328163ca210f"
 
 
    
    private init() {}
    
    public weak var delegate: EkycDelegate?
    
    public func startEkyc(
        config: EkycConfig,
        from viewController: UIViewController
    ) {
        guard let url = buildURL(userId: config.userId) else {
            delegate?.ekycDidFail(
                error: NSError(
                    domain: "EkycSdk",
                    code: 1,
                    userInfo: [NSLocalizedDescriptionKey: "Invalid URL construction"]
                )
            )
            return
        }
        
        let webVC = EkycWebViewController(url: url, themeColor: config.themeColor)
        webVC.delegate = delegate
        
        let nav = UINavigationController(rootViewController: webVC)
        nav.modalPresentationStyle = .fullScreen
        nav.navigationBar.tintColor = config.themeColor
        nav.navigationBar.isTranslucent = false
        
        viewController.present(nav, animated: true, completion: nil)
    }
    
    private func buildURL(userId: String) -> URL? {
        guard var components = URLComponents(string: baseURLString) else {
            return nil
        }
        var items = components.queryItems ?? []
        items.append(URLQueryItem(name: "userId", value: userId))
        components.queryItems = items
        return components.url
    }
}

 
