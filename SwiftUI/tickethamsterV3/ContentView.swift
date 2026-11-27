import SwiftUI
import UIKit

struct ContentView: View {
    @State private var selectedTab = 0

    private let appBackground = Color(red: 0.055, green: 0.055, blue: 0.055)

    var body: some View {
        ZStack(alignment: .bottom) {
            appBackground.ignoresSafeArea()

            TabView(selection: $selectedTab) {
                Discover()
                    .tag(0)

                Favorites()
                    .tag(1)

                Events()
                    .tag(2)

                Account()
                    .tag(3)
            }
            .toolbar(.hidden, for: .tabBar)

            customTabBar
        }
        .preferredColorScheme(.dark)
    }

    private var customTabBar: some View {
        HStack(spacing: 0) {
            tabButton(index: 0, title: "Inicio") {
                HomeTabIcon(isSelected: selectedTab == 0)
            }

            tabButton(index: 1, title: "Watchlist") {
                Image(systemName: selectedTab == 1 ? "bookmark.fill" : "bookmark")
                    .font(.system(size: 20, weight: .regular))
                    .frame(width: 27, height: 27)
                    .foregroundStyle(selectedTab == 1 ? Color.blue : Color.white.opacity(0.72))
            }

            tabButton(index: 2, title: "Mis boletos") {
                Image(uiImage: TicketCountIconAsset.tabImage)
                    .renderingMode(.template)
                    .frame(width: 27, height: 27)
                    .foregroundStyle(selectedTab == 2 ? Color.blue : Color.white.opacity(0.72))
            }

            tabButton(index: 3, title: "Mi cuenta") {
                Image(systemName: selectedTab == 3 ? "person.crop.circle.fill" : "person.crop.circle")
                    .font(.system(size: 22, weight: .regular))
                    .frame(width: 27, height: 27)
                    .foregroundStyle(selectedTab == 3 ? Color.blue : Color.white.opacity(0.72))
            }
        }
        .frame(height: 74)
        .padding(.bottom, 2)
        .background(appBackground)
    }

    private func tabButton<Icon: View>(
        index: Int,
        title: String,
        @ViewBuilder icon: () -> Icon
    ) -> some View {
        Button {
            selectedTab = index
        } label: {
            VStack(spacing: 5) {
                icon()

                Text(title)
                    .font(.system(size: 11.5, weight: selectedTab == index ? .semibold : .regular))
                    .foregroundStyle(selectedTab == index ? Color.blue : .white.opacity(0.62))
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}

private struct HomeTabIcon: View {
    let isSelected: Bool

    var body: some View {
        ZStack {
            Circle()
                .fill(isSelected ? Color(red: 0.00, green: 0.38, blue: 1.00) : Color.clear)
                .overlay(
                    Circle()
                        .stroke(
                            isSelected ? Color.clear : Color.white.opacity(0.88),
                            lineWidth: 1.6
                        )
                )
                .frame(width: 24, height: 24)

            Text("t")
                .font(.system(size: 18, weight: .bold, design: .default))
                .italic()
                .foregroundStyle(.white)
                .offset(x: -0.3, y: -0.8)

            Image(systemName: "sparkle")
                .font(.system(size: 5.4, weight: .bold))
                .foregroundStyle(.white)
                .offset(x: 8.3, y: -8.0)
        }
        .frame(width: 27, height: 27)
    }
}

#Preview {
    ContentView()
}
