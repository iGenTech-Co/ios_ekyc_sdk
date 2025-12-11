import UIKit

public class EkycManager {
    
    public static let shared = EkycManager()
    
    private let baseURL = "https://verify.bantech.ae/?vid=%2Fapi%2F9f998bfb185f4556bed6889ebda98cd4%2Fajil-pay%2Fa09127b249fd4338bc645aba87474477%2Fweb%3Fexpires%3D1765456569%26signature%3Df99b504dd820291419b2a0b1a41001b1ade224400b82f23c870454b4c061acf0"
 
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
