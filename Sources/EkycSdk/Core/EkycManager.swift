import UIKit

public class EkycManager {
    
    public static let shared = EkycManager()
    
    private let baseURL = "https://verify.bantech.ae/?vid=%2Fapi%2Fa0913c4e10504651bbdaa826d8d84f71%2Ftest%2Fa0913e3ba979456888c982061dae9c82%2Fweb%3Fexpires%3D1765460348%26signature%3De261efa8478b83692e8f2baf0d3f6540a93f8c18936a08623606891e0ea0474c"
 
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
