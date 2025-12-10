# How to Run and Test the EkycSdk

Since `EkycSdk` is a **library** (SDK), you cannot "run" it directly. You must run it inside a **Host App**.

Here is the fastest way to test it:

## Step 1: Create a Test App
1. Open **Xcode**.
2. Select **File > New > Project...**
3. Choose **iOS > App** and click Next.
4. Name it `TestEkyc`, select **Swift** and **Storyboard** (or SwiftUI), and create it.

## Step 2: Add the SDK
1. Open Finder and locate your `EkycSdk` folder (where this file is).
2. Drag the **entire `EkycSdk` folder** from Finder into your new Xcode Project's file navigator (left sidebar).
   - *Note: This adds it as a local package.*
3. In your Project Settings (he root node in the sidebar), go to **General** > **Frameworks, Libraries, and Embedded Content**.
4. Click **+** and select `EkycSdk` > `EkycSdk` library.

## Step 3: Call the SDK
1. Open `ViewController.swift` in your new App.
2. Replace the contents with this code:

```swift
import UIKit
// 1. Import the SDK
import EkycSdk

class ViewController: UIViewController, EkycDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add a button to start
        let button = UIButton(type: .system)
        button.setTitle("Start EKYC", for: .normal)
        button.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
        button.addTarget(self, action: #selector(startSdk), for: .touchUpInside)
        view.addSubview(button)
        button.center = view.center
    }

    @objc func startSdk() {
        // 2. Configure and Start
        let config = EkycConfig(userId: "test_user_1", themeColor: .red) // Testing with Red theme
        
        EkycManager.shared.delegate = self
        EkycManager.shared.startEkyc(config: config, from: self)
    }

    // 3. Handle Callbacks
    func ekycDidFinish() {
        print("Test: Finished!")
    }
    
    func ekycDidFail(error: Error) {
        print("Test: Failed with error: \(error)")
    }
    
    func ekycDidCancel() {
        print("Test: User Cancelled")
    }
}
```

## Step 4: Run
1. Select a Simulator (e.g., iPhone 15).
2. Press **Run (Cmd+R)**.
3. Tap the "Start EKYC" button.
4. You should see the WebView load **YouTube** (as we configured it for testing).
