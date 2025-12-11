import UIKit
import WebKit

 

public final class EkycManager {
    
    public static let shared = EkycManager()
    
      private let baseURLString = "https://verify.bantech.ae/?vid=%2Fapi%2Fa0913c4e10504651bbdaa826d8d84f71%2Ftest%2Fa09172500503451281d9591a77354b86%2Fweb%3Fexpires%3D1765469086%26signature%3Dbf6ebee9825a1a15dcbfb427b42bf9873e53a6cccfbda0e0625eb91b1baf3450"

 
 
    
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

 
