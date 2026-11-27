import SwiftUI
import FirebaseCore
import FirebaseFirestore

@main
struct tickethamsterV3App: App {

    init() {
        FirebaseApp.configure()

        let settings = FirestoreSettings()
        settings.cacheSettings = PersistentCacheSettings(
            sizeBytes: 100 * 1024 * 1024 as NSNumber
        )
        Firestore.firestore().settings = settings
    }

    var body: some Scene {
        WindowGroup {
            RootLaunchView()
        }
    }
}

private struct RootLaunchView: View {
    @State private var showApp = false

    var body: some View {
        ZStack {
            if showApp {
                ContentView()
                    .transition(.opacity)
            } else {
                SplashView()
                    .transition(.opacity)
            }
        }
        .background(Color(red: 0.065, green: 0.065, blue: 0.065))
        .task {
            try? await Task.sleep(for: .milliseconds(1200))

            withAnimation(.easeOut(duration: 0.22)) {
                showApp = true
            }
        }
    }
}

private struct SplashView: View {
    var body: some View {
        ZStack {
            Color(red: 0.065, green: 0.065, blue: 0.065)
                .ignoresSafeArea()

            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 280)
                .foregroundStyle(.white)
        }
        .preferredColorScheme(.dark)
    }
}
