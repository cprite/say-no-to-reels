import SwiftUI
import UIKit

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

/// Full-screen UIViewController hosting the Instagram web view.
final class WebViewController: UIViewController {
    private let model = WebViewModel()
    private var hasLoaded = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        edgesForExtendedLayout = .all
        extendedLayoutIncludesOpaqueBars = true

        let wv = model.webView
        wv.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(wv)

        // Floating refresh button
        let refreshBtn = UIButton(type: .system)
        refreshBtn.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        refreshBtn.tintColor = .white
        refreshBtn.backgroundColor = UIColor(white: 0.2, alpha: 0.8)
        refreshBtn.layer.cornerRadius = 20
        refreshBtn.translatesAutoresizingMaskIntoConstraints = false
        refreshBtn.addAction(UIAction { [weak model] _ in model?.reload() }, for: .touchUpInside)
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
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !hasLoaded {
            hasLoaded = true
            model.loadInbox()
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
}
