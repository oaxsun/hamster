import SwiftUI
import UIKit

struct ContentView: View {
    private let homeIcon = TabBarIconFactory.homeIcon
    private let watchlistIcon = TabBarIconFactory.normalizedSymbol("bookmark")
    private let ticketsIcon = TabBarIconFactory.normalizedImage(TicketCountIconAsset.image)
    private let accountIcon = TabBarIconFactory.normalizedSymbol("person.crop.circle")

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
    private static let canvas = CGSize(width: 27, height: 27)
    private static let contentBox = CGRect(x: 2.5, y: 2.5, width: 22, height: 22)

    static let homeIcon: UIImage = {
        let renderer = UIGraphicsImageRenderer(size: canvas)

        return renderer.image { _ in
            UIColor(red: 0.00, green: 0.38, blue: 1.00, alpha: 1.00).setFill()
            UIBezierPath(ovalIn: contentBox).fill()

            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .center

            let base = UIFont.systemFont(ofSize: 19.5, weight: .black)
            let font = base.fontDescriptor.withSymbolicTraits([.traitItalic, .traitBold])
                .map { UIFont(descriptor: $0, size: 19.5) } ?? base

            let attrs: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.white,
                .paragraphStyle: paragraph
            ]

            let tRect = CGRect(x: 2.25, y: 2.3, width: 22.5, height: 22.5)
            ("t" as NSString).draw(in: tRect, withAttributes: attrs)

            if let star = UIImage(systemName: "sparkle")?
                .withTintColor(.white, renderingMode: .alwaysOriginal) {
                star.draw(in: CGRect(x: 19.0, y: 2.0, width: 5.8, height: 5.8))
            }
        }
        .withRenderingMode(.alwaysOriginal)
    }()

    static func normalizedSymbol(_ name: String) -> UIImage {
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .regular)
        let source = UIImage(systemName: name, withConfiguration: config) ?? UIImage()
        return normalizedImage(source)
    }

    static func normalizedImage(_ source: UIImage) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: canvas)

        let rendered = renderer.image { _ in
            guard source.size.width > 0, source.size.height > 0 else { return }

            let scale = min(
                contentBox.width / source.size.width,
                contentBox.height / source.size.height
            )

            let drawSize = CGSize(
                width: source.size.width * scale,
                height: source.size.height * scale
            )

            let drawRect = CGRect(
                x: (canvas.width - drawSize.width) / 2,
                y: (canvas.height - drawSize.height) / 2,
                width: drawSize.width,
                height: drawSize.height
            )

            source.withRenderingMode(.alwaysTemplate).draw(in: drawRect)
        }

        return rendered.withRenderingMode(.alwaysTemplate)
    }
}

#Preview {
    ContentView()
}
