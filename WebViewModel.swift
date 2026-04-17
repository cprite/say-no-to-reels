import Foundation
import WebKit
import Combine

/// Manages the WKWebView configuration, script injection, and navigation policy.
final class WebViewModel: NSObject, ObservableObject {

    // MARK: - Published state

    @Published var canGoBack: Bool = false
    @Published var canGoForward: Bool = false
    @Published var isLoading: Bool = false
    @Published var pageTitle: String = ""

    // MARK: - Constants

    static let instagramDMURL = URL(string: "https://www.instagram.com/direct/inbox/")!
    static let instagramHost  = "www.instagram.com"

    // MARK: - WebView

    let webView: WKWebView

    // MARK: - Init

    static func makeWebView(frame: CGRect) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = .default()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []

        if let url = Bundle.main.url(forResource: "InstagramBlocker", withExtension: "js"),
           let src = try? String(contentsOf: url, encoding: .utf8) {
            config.userContentController.addUserScript(
                WKUserScript(source: src, injectionTime: .atDocumentStart, forMainFrameOnly: false)
            )
        }

        let wv = WKWebView(frame: frame, configuration: config)
        wv.isOpaque = true
        wv.backgroundColor = .black
        wv.scrollView.backgroundColor = .black
        wv.scrollView.bounces = false
        wv.scrollView.contentInsetAdjustmentBehavior = .never
        wv.scrollView.contentInset = .zero
        wv.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Mobile/21E236 Safari/604.1"
        return wv
    }

    override init() {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = .default()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []

        if let url = Bundle.main.url(forResource: "InstagramBlocker", withExtension: "js"),
           let src = try? String(contentsOf: url, encoding: .utf8) {
            config.userContentController.addUserScript(
                WKUserScript(source: src, injectionTime: .atDocumentStart, forMainFrameOnly: false)
            )
        }

        webView = WKWebView(frame: .zero, configuration: config)
        webView.isOpaque = true
        webView.backgroundColor = .black
        webView.scrollView.backgroundColor = .black
        webView.scrollView.bounces = false
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Mobile/21E236 Safari/604.1"

        super.init()

        webView.navigationDelegate = self
        webView.uiDelegate = self

        // Observe loading / navigation state
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.canGoBack),    options: .new, context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.canGoForward), options: .new, context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.isLoading),    options: .new, context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title),        options: .new, context: nil)
    }

    deinit {
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.canGoBack))
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.canGoForward))
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.isLoading))
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.title))
    }

    // MARK: - KVO

    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey: Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.canGoBack    = self.webView.canGoBack
            self.canGoForward = self.webView.canGoForward
            self.isLoading    = self.webView.isLoading
            self.pageTitle    = self.webView.title ?? ""
        }
    }

    // MARK: - Navigation helpers

    func loadInbox() {
        webView.load(URLRequest(url: Self.instagramDMURL))
    }

    func goBack()    { webView.goBack() }
    func goForward() { webView.goForward() }
    func reload()    { webView.reload() }
}

// MARK: - WKNavigationDelegate

extension WebViewModel: WKNavigationDelegate {

    /// Block navigation to Reels URLs entirely.
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }

        let path = url.path.lowercased()

        // Block /reels/ and individual reel posts (/reel/...)
        if path.hasPrefix("/reels") || path.hasPrefix("/reel/") {
            decisionHandler(.cancel)
            return
        }

        // Block Explore page
        // if path.hasPrefix("/explore") { decisionHandler(.cancel); return }

        // Only allow instagram.com (prevent accidental external navigation)
        if let host = url.host, host != Self.instagramHost, !host.hasSuffix(".instagram.com") {
            // Open external links in Safari instead
            if navigationAction.navigationType == .linkActivated {
                UIApplication.shared.open(url)
                decisionHandler(.cancel)
                return
            }
        }

        decisionHandler(.allow)
    }
}

// MARK: - WKUIDelegate

extension WebViewModel: WKUIDelegate {
    // Allow Instagram's JS to open new windows (e.g. OAuth pop-ups during login)
    func webView(
        _ webView: WKWebView,
        createWebViewWith configuration: WKWebViewConfiguration,
        for navigationAction: WKNavigationAction,
        windowFeatures: WKWindowFeatures
    ) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
}
