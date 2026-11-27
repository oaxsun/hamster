import SwiftUI

struct ContentView: View {
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.black

        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.white
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]

        appearance.stackedLayoutAppearance.selected.iconColor = UIColor.systemBlue
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            TabView {
                Discover()
                    .tabItem {
                        Image("discover")
                        Text("Inicio")
                    }

                Favorites()
                    .tabItem {
                        Image("favorites")
                        Text("Watchlist")
                    }

                Events()
                    .tabItem {
                        Image(uiImage: TicketCountIconAsset.image)
                            .renderingMode(.template)
                        Text("Mis boletos")
                    }

                Account()
                    .tabItem {
                        Image("profile")
                        Text("Mi cuenta")
                    }
            }
            .tint(.blue)
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
