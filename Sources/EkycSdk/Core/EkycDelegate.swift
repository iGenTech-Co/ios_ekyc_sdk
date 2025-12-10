import Foundation

public protocol EkycDelegate: AnyObject {
    func ekycDidFinish()
    func ekycDidFail(error: Error)
    func ekycDidCancel()
}
