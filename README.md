# EkycSdk

This SDK provides a simple way to integrade a WebView-based EKYC flow into your iOS application.

## Integration

### Swift Package Manager (SPM) via GitHub

1.  **Push** this code to a public or private GitHub repository.
2.  **Tag** a release (e.g., `git tag 1.0.0`, `git push --tags`) so SPM can manage versions.
3.  In your App (Xcode):
    - Go to **File > Add Packages...**
    - Enter your **GitHub Repository URL**: `https://github.com/iGenTech-Co/ios_ekyc_sdk.git`
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

## Camera & Microphone Permissions

The SDK requires camera and microphone access for eKYC verification. **You must add the following keys to your app's `Info.plist`:**

```xml
<key>NSCameraUsageDescription</key>
<string>We need access to your camera for identity verification</string>
<key>NSMicrophoneUsageDescription</key>
<string>We need access to your microphone for identity verification</string>
```

**Important Notes:**
- The SDK automatically handles WebView permission requests
- Your app must include these Info.plist keys or the camera/microphone will not work
- Customize the description strings to match your app's use case
- iOS will show these messages when requesting permission from the user

## Requirements

- iOS 13.0+
- Swift 5.0+
