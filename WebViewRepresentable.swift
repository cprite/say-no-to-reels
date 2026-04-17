import SwiftUI
import WebKit

/// Bridges WKWebView into SwiftUI.
struct WebViewRepresentable: UIViewRepresentable {

    let webView: WKWebView
    let onLayout: () -> Void

    func makeUIView(context: Context) -> UIView {
        let container = WebViewContainer(webView: webView, onLayout: onLayout)
        container.backgroundColor = .black
        return container
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

/// Container that pins WKWebView to its bounds and reloads once it has a real size.
final class WebViewContainer: UIView {

    private let webView: WKWebView
    private let onLayout: () -> Void
    private var didLayout = false

    init(webView: WKWebView, onLayout: @escaping () -> Void) {
        self.webView = webView
        self.onLayout = onLayout
        super.init(frame: .zero)

        webView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: topAnchor),
            webView.bottomAnchor.constraint(equalTo: bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    override func layoutSubviews() {
        super.layoutSubviews()
        if !didLayout && bounds.width > 0 && bounds.height > 0 {
            didLayout = true
            onLayout()
        }
    }
}
