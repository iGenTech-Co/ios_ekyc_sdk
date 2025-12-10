# EkycSdk

This SDK provides a simple way to integrade a WebView-based EKYC flow into your iOS application.

## Integration

### Swift Package Manager (SPM) via GitHub

1.  **Push** this code to a public or private GitHub repository.
2.  **Tag** a release (e.g., `git tag 1.0.0`, `git push --tags`) so SPM can manage versions.
3.  In your App (Xcode):
    - Go to **File > Add Packages...**
    - Enter your **GitHub Repository URL** (e.g., `https://github.com/username/EkycSdk.git`).
    - Choose the version rule (e.g., "Up to Next Major" -> `1.0.0`).
4.  Select the `EkycSdk` product.

### Manual Integration

1.  Drag the `Sources/EkycSdk` folder into your project.
2.  Ensure needed files are in your "Compile Sources" build phase.

## Usage

In your client application's View Controller:

1.  **Import the SDK**:
    ```swift
    import EkycSdk
    ```

2.  **Conform to `EkycDelegate`**:
    ```swift
    class ViewController: UIViewController, EkycDelegate {
        
        // ...
        
        func ekycDidFinish() {
             print("EKYC Completed!")
        }
        
        func ekycDidFail(error: Error) {
             print("EKYC Failed: \(error.localizedDescription)")
        }
        
        func ekycDidCancel() {
             print("User cancelled EKYC")
        }
    }
    ```

3.  **Start the Flow**:
    ```swift
    @IBAction func startVerificationTapped(_ sender: Any) {
        // Create Configuration
        let config = EkycConfig(userId: "user_12345", themeColor: .systemPurple)
        
        // Set Delegate
        EkycManager.shared.delegate = self
        
        // Start
        EkycManager.shared.startEkyc(config: config, from: self)
    }
    ```

## Requirements

- iOS 13.0+
- Swift 5.0+
