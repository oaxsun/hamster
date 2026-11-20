import SwiftUI
import FirebaseCore
import FirebaseFirestore

@main
struct tickethamsterV3App: App {

    init() {
        FirebaseApp.configure()

        // Persistent Firestore cache for offline use.
        // Firestore will serve the last cached data while offline and
        // snapshot listeners will refresh automatically when connectivity returns.
        let settings = FirestoreSettings()
        settings.cacheSettings = PersistentCacheSettings(
            sizeBytes: 100 * 1024 * 1024 as NSNumber
        )
        Firestore.firestore().settings = settings
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
