
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

## Step 3: Integration Code

### Option A: UIKit (Storyboard/ViewController)
Open `ViewController.swift` and replace contents:

```swift
import UIKit
import EkycSdk

class ViewController: UIViewController, EkycDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(type: .system)
        button.setTitle("Start EKYC", for: .normal)
        button.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
        button.addTarget(self, action: #selector(startSdk), for: .touchUpInside)
        view.addSubview(button)
        button.center = view.center
    }

    @objc func startSdk() {
        let config = EkycConfig(userId: "test_user_1", themeColor: .red)
        EkycManager.shared.delegate = self
        EkycManager.shared.startEkyc(config: config, from: self)
    }

    func ekycDidFinish() {}
    func ekycDidFail(error: Error) {}
    func ekycDidCancel() {}
}
```

### Option B: SwiftUI
Open `ContentView.swift` and replace contents:

```swift
import SwiftUI
import EkycSdk

// 1. Create a partial helper functionality
class EkycViewModel: NSObject, ObservableObject, EkycDelegate {
    func startEkyc() {
        // Helper to find the top ViewController
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = scene.windows.first?.rootViewController else { return }
        
        let config = EkycConfig(userId: "swiftui_user", themeColor: .purple)
        EkycManager.shared.delegate = self
        EkycManager.shared.startEkyc(config: config, from: rootVC)
    }
    
    func ekycDidFinish() { print("Done") }
    func ekycDidFail(error: Error) { print("Fail: \(error)") }
    func ekycDidCancel() { print("Cancel") }
}

struct ContentView: View {
    @StateObject private var viewModel = EkycViewModel()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("EKYC SDK")
            
            Button("Start Verification") {
                viewModel.startEkyc()
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .padding()
    }
}
```
