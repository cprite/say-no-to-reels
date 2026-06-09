import Foundation
import WebKit
import UIKit

/// Owns the configured `WKWebView`: script injection, navigation policy, and
/// pop-up handling. A single instance backs the whole app — its `webView` is
/// added directly to `WebViewController`'s view hierarchy.
final class WebViewModel: NSObject {

    // MARK: - Constants

    static let instagramDMURL = URL(string: "https://www.instagram.com/direct/inbox/")!
    static let instagramHost  = "www.instagram.com"

    // Pinned to a recent iOS Safari UA so Instagram serves its modern mobile
    // web layout. Bump this if Instagram starts serving a degraded page.
    private static let mobileSafariUserAgent =
        "Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Mobile/21E236 Safari/604.1"

    // MARK: - WebView

    let webView: WKWebView

    // MARK: - Init

    override init() {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = .default()              // persist login between sessions
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []

        // Inject the Reels-hiding script at document start, before IG renders.
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
        webView.scrollView.contentInset = .zero
        webView.customUserAgent = Self.mobileSafariUserAgent

        super.init()

        webView.navigationDelegate = self
        webView.uiDelegate = self
    }

    // MARK: - Navigation helpers

    func loadInbox() { webView.load(URLRequest(url: Self.instagramDMURL)) }
    func reload()    { webView.reload() }
}

// MARK: - WKNavigationDelegate

extension WebViewModel: WKNavigationDelegate {

    /// Hard-blocks navigation to Reels URLs — the robust counterpart to the
    /// CSS/DOM hiding in InstagramBlocker.js. Together they make sure a Reel
    /// can't be opened even if a tile slips past the cosmetic filter.
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

        // Keep navigation inside Instagram; open tapped external links in Safari.
        if let host = url.host,
           host != Self.instagramHost,
           !host.hasSuffix(".instagram.com"),
           navigationAction.navigationType == .linkActivated {
            UIApplication.shared.open(url)
            decisionHandler(.cancel)
            return
        }

        decisionHandler(.allow)
    }
}

// MARK: - WKUIDelegate

extension WebViewModel: WKUIDelegate {

    /// Load target="_blank" links (e.g. OAuth pop-ups during login) in the
    /// same web view instead of dropping them.
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
