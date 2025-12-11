import UIKit
import WebKit

/// A view controller that displays eKYC content in a full-screen WebView
/// with zero padding and custom theming support
class EkycWebViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let errorTitle = "Error"
        static let errorButtonTitle = "OK"
    }
    
    // MARK: - Properties
    
    /// The URL to load in the WebView
    private let url: URL
    
    /// Theme color used for UI elements (activity indicator, navigation bar)
    private let themeColor: UIColor
    
    /// Delegate to handle eKYC events (success, failure, cancellation)
    weak var delegate: EkycDelegate?
    
    /// Main WebView component - displays the eKYC web content
    private var webView: WKWebView!
    
    /// Loading indicator shown while the page is loading
    private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Initialization
    
    /// Initializes the WebView controller with a URL and theme color
    /// - Parameters:
    ///   - url: The URL to load in the WebView
    ///   - themeColor: Color for theming UI elements
    init(url: URL, themeColor: UIColor) {
        self.url = url
        self.themeColor = themeColor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWebView()
        setupActivityIndicator()
        setupNavigationBar()
        
        loadUrl()
    }
    
    // MARK: - Setup Methods
    
    /// Configures the WebView with zero padding and full-screen layout
    private func setupWebView() {
        // Create WebView configuration
        let webConfiguration = WKWebViewConfiguration()
        
        // Allow inline media playback (useful for videos in eKYC flows)
        webConfiguration.allowsInlineMediaPlayback = true
        
        // Initialize WebView with configuration
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        
        // CRITICAL: Remove ALL automatic insets and padding
        // This ensures the WebView content fills the entire screen with zero padding
        
        // 1. Disable automatic content inset adjustment (iOS 11+)
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        }
        
        // 2. Set all insets to zero
        webView.scrollView.contentInset = .zero
        webView.scrollView.scrollIndicatorInsets = .zero
        
        // 3. Remove any automatic margins
        webView.scrollView.automaticallyAdjustsScrollIndicatorInsets = false
        
        // 4. Ensure opaque background (no transparency)
        webView.isOpaque = true
        webView.backgroundColor = .white
        
        // Setup Auto Layout
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        
        // Pin WebView to the ENTIRE view (not safe area) for zero padding
        // This ensures edge-to-edge content display
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    /// Configures the loading indicator
    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = themeColor
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        // Center the activity indicator
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    /// Configures the navigation bar with a close button
    private func setupNavigationBar() {
        // Set background color based on iOS version
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        
        // Add close/cancel button
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(closeTapped)
        )
        navigationItem.leftBarButtonItem?.tintColor = themeColor
    }
    
    /// Loads the eKYC URL in the WebView
    private func loadUrl() {
        activityIndicator.startAnimating()
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    // MARK: - Actions
    
    /// Handles the close button tap - dismisses the view and notifies delegate
    @objc private func closeTapped() {
        dismiss(animated: true) {
            self.delegate?.ekycDidCancel()
        }
    }
    
    /// Shows an error alert to the user
    /// - Parameter error: The error to display
    private func showErrorAlert(for error: Error) {
        let alert = UIAlertController(
            title: Constants.errorTitle,
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
            title: Constants.errorButtonTitle,
            style: .default,
            handler: { [weak self] _ in
                self?.closeTapped()
            }
        ))
        
        present(alert, animated: true)
    }
}

// MARK: - WKNavigationDelegate

extension EkycWebViewController: WKNavigationDelegate {
    
    /// Called when the WebView finishes loading
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    /// Called when navigation fails after content has started loading
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
        showErrorAlert(for: error)
        delegate?.ekycDidFail(error: error)
    }
    
    /// Called when navigation fails before content starts loading
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
        showErrorAlert(for: error)
        delegate?.ekycDidFail(error: error)
    }
}
