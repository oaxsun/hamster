import SwiftUI

struct Favorites: View {
    @State private var selectedSection: WatchlistSection = .events

    enum WatchlistSection: String, CaseIterable {
        case events = "Events"
        case favorites = "Favoritos"
    }

    var body: some View {
        ZStack {
            Color(red: 0.055, green: 0.055, blue: 0.055).ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    header
                        .padding(.top, 18)

                    segmentedControl
                        .padding(.top, 26)

                    Group {
                        switch selectedSection {
                        case .events:
                            eventsEmptyState
                        case .favorites:
                            favoritesEmptyState
                        }
                    }
                    .padding(.top, 42)
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 120)
            }
        }
        .preferredColorScheme(.dark)
    }

    private var header: some View {
        VStack(spacing: 2) {
            Text("WATCHLIST")
                .font(.system(size: 20, weight: .heavy))
                .foregroundStyle(.white)

            Text("Events saved for the right moment")
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(.white.opacity(0.88))
        }
        .frame(maxWidth: .infinity)
    }

    private var segmentedControl: some View {
        HStack(spacing: 0) {
            segmentButton(.events, systemImage: "bookmark.fill")
            segmentButton(.favorites, systemImage: "heart")
        }
        .padding(3)
        .frame(height: 46)
        .background(
            Capsule()
                .fill(Color.black)
                .overlay(
                    Capsule()
                        .stroke(Color.white.opacity(0.18), lineWidth: 1)
                )
        )
    }

    private func segmentButton(_ section: WatchlistSection, systemImage: String) -> some View {
        let selected = selectedSection == section

        return Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedSection = section
            }
        } label: {
            HStack(spacing: 8) {
                Image(systemName: systemImage)
                    .font(.system(size: 14, weight: .semibold))

                Text(section.rawValue)
                    .font(.system(size: 15, weight: selected ? .bold : .medium))
            }
            .foregroundStyle(selected ? Color.black : Color.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Capsule()
                    .fill(selected ? watchlistAccent : Color.clear)
            )
        }
        .buttonStyle(.plain)
    }

    private var eventsEmptyState: some View {
        VStack(spacing: 0) {
            Image(systemName: "bookmark")
                .font(.system(size: 35, weight: .regular))
                .foregroundStyle(.white)

            Rectangle()
                .fill(watchlistAccent)
                .frame(width: 85, height: 2)
                .padding(.top, 38)

            Text("No events added")
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(.white)
                .padding(.top, 22)

            VStack(spacing: 27) {
                benefitRow(
                    icon: "calendar.badge.plus",
                    title: "Save Events",
                    description: "Easily jump back into events that you have an interest in\ngoing to"
                )

                benefitRow(
                    icon: "bell",
                    title: "Never Miss A Presale",
                    description: "Set alerts so you never miss out on those presale tickets"
                )

                benefitRow(
                    icon: "info.circle",
                    title: "Stay Informed",
                    description: "Receive alerts and updates about key event information"
                )
            }
            .padding(.top, 40)
        }
        .frame(maxWidth: .infinity)
    }

    private var favoritesEmptyState: some View {
        VStack(spacing: 0) {
            Image(systemName: "heart")
                .font(.system(size: 35, weight: .regular))
                .foregroundStyle(.white)

            Rectangle()
                .fill(watchlistAccent)
                .frame(width: 85, height: 2)
                .padding(.top, 38)

            Text("No favorites added")
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(.white)
                .padding(.top, 22)

            VStack(spacing: 27) {
                benefitRow(
                    icon: "heart",
                    title: "Save Favorites",
                    description: "Keep artists, teams and venues you care about in one place"
                )

                benefitRow(
                    icon: "bell",
                    title: "Get Event Alerts",
                    description: "Receive updates when new events are announced"
                )

                benefitRow(
                    icon: "info.circle",
                    title: "Stay Informed",
                    description: "Get updates about the favorites that matter to you"
                )
            }
            .padding(.top, 40)
        }
        .frame(maxWidth: .infinity)
    }

    private func benefitRow(icon: String, title: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 18) {
            Image(systemName: icon)
                .font(.system(size: 19, weight: .regular))
                .foregroundStyle(watchlistAccent)
                .frame(width: 22)
                .padding(.top, 2)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.white)

                Text(description)
                    .font(.system(size: 12.5, weight: .regular))
                    .foregroundStyle(.white.opacity(0.95))
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 30)
    }

    private var watchlistAccent: Color {
        Color(red: 0.78, green: 0.31, blue: 0.96)
    }
}

#Preview {
    Favorites()
}
