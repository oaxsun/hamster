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

            guard
                let logo = UIImage(named: "logo"),
                let cgImage = logo.cgImage
            else { return }

            // Use the exact first "t" from the Ticketmaster wordmark used by the splash.
            let cropWidth = Int(CGFloat(cgImage.width) * 0.135)
            let cropRect = CGRect(
                x: 0,
                y: 0,
                width: cropWidth,
                height: cgImage.height
            )

            guard let croppedCG = cgImage.cropping(to: cropRect) else { return }

            let cropped = UIImage(
                cgImage: croppedCG,
                scale: logo.scale,
                orientation: logo.imageOrientation
            )

            let target = CGRect(x: 6.0, y: 4.2, width: 15.0, height: 19.0)
            cropped.draw(in: target, blendMode: .normal, alpha: 1.0)
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
