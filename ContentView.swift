import SwiftUI

struct ContentView: View {

    @StateObject private var vm = WebViewModel()

    var body: some View {
        WebViewRepresentable(webView: vm.webView, onLayout: {})
            .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
