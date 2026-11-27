import SwiftUI
import UIKit

struct ContentView: View {
    private let homeIcon = TabBarIconFactory.homeIcon
    private let watchlistIcon = TabBarIconFactory.symbol("bookmark", pointSize: 24)
    private let ticketsIcon = TicketCountIconAsset.tabImage
    private let accountIcon = TabBarIconFactory.symbol("person.crop.circle", pointSize: 25)

    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.black

        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.white
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(white: 0.62, alpha: 1)
        ]

        appearance.stackedLayoutAppearance.selected.iconColor = UIColor.systemBlue
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 12, weight: .semibold)
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
                        Image(uiImage: homeIcon)
                            .renderingMode(.original)
                        Text("Inicio")
                    }

                Favorites()
                    .tabItem {
                        Image(uiImage: watchlistIcon)
                            .renderingMode(.template)
                        Text("Watchlist")
                    }

                Events()
                    .tabItem {
                        Image(uiImage: ticketsIcon)
                            .renderingMode(.template)
                        Text("Mis boletos")
                    }

                Account()
                    .tabItem {
                        Image(uiImage: accountIcon)
                            .renderingMode(.template)
                        Text("Mi cuenta")
                    }
            }
            .tint(.blue)
        }
        .preferredColorScheme(.dark)
    }
}

private enum TabBarIconFactory {
    static let homeIcon: UIImage = {
        let size = CGSize(width: 27, height: 27)
        let renderer = UIGraphicsImageRenderer(size: size)

        return renderer.image { context in
            let bounds = CGRect(origin: .zero, size: size)
            UIColor.systemBlue.setFill()
            UIBezierPath(ovalIn: bounds).fill()

            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .center

            let font = UIFont.italicSystemFont(ofSize: 22)
            let attrs: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.white,
                .paragraphStyle: paragraph
            ]

            let tRect = CGRect(x: 0, y: 1.5, width: size.width, height: size.height)
            ("t" as NSString).draw(in: tRect, withAttributes: attrs)

            if let star = UIImage(systemName: "sparkle")?
                .withTintColor(.white, renderingMode: .alwaysOriginal) {
                star.draw(in: CGRect(x: 19.4, y: 0.4, width: 7, height: 7))
            }
        }
        .withRenderingMode(.alwaysOriginal)
    }()

    static func symbol(_ name: String, pointSize: CGFloat) -> UIImage {
        let config = UIImage.SymbolConfiguration(pointSize: pointSize, weight: .regular)
        return (UIImage(systemName: name, withConfiguration: config) ?? UIImage())
            .withRenderingMode(.alwaysTemplate)
    }
}

#Preview {
    ContentView()
}
