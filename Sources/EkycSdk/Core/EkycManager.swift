import UIKit

public class EkycManager {
    
    public static let shared = EkycManager()
    
    private let baseURL = "https://verify.bantech.ae/?vid=%2Fapi%2F9f998bfb185f4556bed6889ebda98cd4%2Fajil-pay%2Fa091353e5d1e4351a93aeb35e9e4e020%2Fweb%3Fexpires%3D1765458842%26signature%3Dcefd23333658ad0917d84919811d45cafb25752fb3ad886090b3812737025883"
 
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
