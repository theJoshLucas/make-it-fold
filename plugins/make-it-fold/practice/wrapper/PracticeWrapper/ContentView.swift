import SwiftUI

struct ContentView: View {
    var body: some View {
        // The page draws edge to edge and handles its own insets.
        WebView()
            .ignoresSafeArea()
    }
}
