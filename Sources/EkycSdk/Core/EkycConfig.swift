import UIKit

public struct EkycConfig {
    public let userId: String
    
    public let themeColor: UIColor
    
    public init(userId: String, themeColor: UIColor = .systemBlue) {
        self.userId = userId
        self.themeColor = themeColor
    }
}
