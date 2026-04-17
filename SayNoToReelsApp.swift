import SwiftUI
import UIKit
import WebKit

@main
struct SayNoToReelsApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .ignoresSafeArea()
                .preferredColorScheme(.dark)
        }
    }
}

/// Thin SwiftUI wrapper that installs a full-screen UIViewController.
struct RootView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> WebViewController {
        WebViewController()
    }
    func updateUIViewController(_ vc: WebViewController, context: Context) {}
}

/// Full-screen UIViewController — creates WKWebView after the window is ready.
final class WebViewController: UIViewController {
    private var webView: WKWebView?
    private var hasLoaded = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        edgesForExtendedLayout = .all
        extendedLayoutIncludesOpaqueBars = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if !hasLoaded {
            hasLoaded = true

            let wv = WebViewModel.makeWebView(frame: view.bounds)
            wv.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(wv)

            // Refresh button
            let refreshBtn = UIButton(type: .system)
            refreshBtn.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
            refreshBtn.tintColor = .white
            refreshBtn.backgroundColor = UIColor(white: 0.2, alpha: 0.8)
            refreshBtn.layer.cornerRadius = 20
            refreshBtn.translatesAutoresizingMaskIntoConstraints = false
            refreshBtn.addAction(UIAction { _ in wv.reload() }, for: .touchUpInside)
            view.addSubview(refreshBtn)

            NSLayoutConstraint.activate([
                wv.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                wv.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                wv.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                wv.trailingAnchor.constraint(equalTo: view.trailingAnchor),

                refreshBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                refreshBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
                refreshBtn.widthAnchor.constraint(equalToConstant: 40),
                refreshBtn.heightAnchor.constraint(equalToConstant: 40),
            ])
            self.webView = wv
            wv.load(URLRequest(url: WebViewModel.instagramDMURL))
        }
    }

    override var prefersStatusBarHidden: Bool { false }
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
}
