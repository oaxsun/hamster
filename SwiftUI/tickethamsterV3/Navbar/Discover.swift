import SwiftUI
import FirebaseFirestore

struct Discover: View {
    @State private var events: [Event] = []
    @State private var isLoadingEvents = false
    @State private var eventsError: String?
    @State private var searchText = ""
    @State private var showEventError = false
    @State private var discoverListener: ListenerRegistration?

    private let accentBlue = Color(red: 0.03, green: 0.35, blue: 0.95)
    private let accentCyan = Color(red: 0.00, green: 0.86, blue: 0.79)
    private let cardBackground = Color(red: 0.115, green: 0.115, blue: 0.115)

    var body: some View {
        ZStack {
            Color(red: 0.055, green: 0.055, blue: 0.055).ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    locationHeader
                        .padding(.top, 16)

                    searchBar
                        .padding(.top, 22)

                    forYouSection
                        .padding(.top, 34)

                    trendingSection
                        .padding(.top, 34)

                    lastChanceSection
                        .padding(.top, 34)
                        .padding(.bottom, 36)
                }
            }
        }
        .preferredColorScheme(.dark)
        .fullScreenCover(isPresented: $showEventError) {
            ErrorEvent()
        }
        .onAppear {
            listenToDiscoverEvents()
        }
        .onDisappear {
            discoverListener?.remove()
            discoverListener = nil
        }
    }

    private var locationHeader: some View {
        Button(action: {}) {
            HStack(spacing: 10) {
                Image(systemName: "mappin.square.fill")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(accentCyan)

                Text("Ciudad de México y área metropolitana")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .lineLimit(1)

                Image(systemName: "chevron.right")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.white)

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 18)
        }
        .buttonStyle(.plain)
    }

    private var searchBar: some View {
        HStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(accentBlue)
                    .frame(width: 44, height: 44)

                Image(systemName: "magnifyingglass")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(.white)
            }

            TextField("Search for Recintos", text: $searchText)
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(.white)
                .tint(.white)

            Spacer(minLength: 0)
        }
        .padding(.leading, 10)
        .padding(.trailing, 18)
        .frame(height: 64)
        .background(Color(red: 0.13, green: 0.13, blue: 0.13))
        .clipShape(Capsule())
        .padding(.horizontal, 18)
    }

    private var forYouSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("For You")

            if isLoadingEvents && events.isEmpty {
                loadingStrip
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(forYouEvents) { event in
                            Button {
                                showEventError = true
                            } label: {
                                ForYouCard(event: event, accentCyan: accentCyan, cardBackground: cardBackground)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 18)
                }
            }
        }
    }

    private var trendingSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Trending In México")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)

                Spacer()

                Button("View All") {}
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 18)

            if isLoadingEvents && events.isEmpty {
                loadingStrip
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 18) {
                        ForEach(Array(trendingGroups.enumerated()), id: \.offset) { groupIndex, group in
                            VStack(spacing: 8) {
                                ForEach(Array(group.enumerated()), id: \.element.id) { itemIndex, event in
                                    Button {
                                        showEventError = true
                                    } label: {
                                        TrendingRow(
                                            event: event,
                                            rank: groupIndex * 3 + itemIndex + 1,
                                            cardBackground: cardBackground
                                        )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .frame(width: 400)
                        }
                    }
                    .padding(.horizontal, 18)
                }
            }
        }
    }

    private var lastChanceSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Last Chance")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)

                Spacer()

                Button("View All") {}
                    .font(.system(size: 12))
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 18)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(lastChanceEvents) { event in
                        Button {
                            showEventError = true
                        } label: {
                            LastChanceCard(event: event)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 18)
            }
        }
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 18, weight: .bold))
            .foregroundStyle(.white)
            .padding(.horizontal, 18)
    }

    private var loadingStrip: some View {
        HStack {
            Spacer()
            ProgressView().tint(.white)
            Spacer()
        }
        .frame(height: 170)
    }

    private var forYouEvents: [Event] {
        Array(displayEvents.prefix(6))
    }

    private var lastChanceEvents: [Event] {
        let source = displayEvents.count > 3 ? Array(displayEvents.dropFirst(3)) : displayEvents
        return Array(source.prefix(6))
    }

    private var trendingGroups: [[Event]] {
        let source = Array(displayEvents.prefix(6))
        guard !source.isEmpty else { return [] }
        return stride(from: 0, to: source.count, by: 3).map { start in
            Array(source[start..<min(start + 3, source.count)])
        }
    }

    private var displayEvents: [Event] {
        if !events.isEmpty { return events }
        return Event.previewHomeEvents
    }

    private func listenToDiscoverEvents() {
        isLoadingEvents = events.isEmpty
        eventsError = nil

        discoverListener?.remove()
        discoverListener = Firestore.firestore()
            .collection("Event")
            .document("Discover")
            .collection("Eventos")
            .addSnapshotListener(includeMetadataChanges: true) { snapshot, error in
                isLoadingEvents = false

                if let error = error {
                    eventsError = error.localizedDescription
                    return
                }

                guard let docs = snapshot?.documents else { return }

                let numericDocs = docs
                    .filter { Int($0.documentID) != nil }
                    .sorted { (Int($0.documentID) ?? 0) < (Int($1.documentID) ?? 0) }

                events = numericDocs.compactMap { doc in
                    let data = doc.data()
                    let nombre = data["Nombre"] as? String ?? ""
                    let lugar = data["Lugar"] as? String ?? ""
                    let url = data["EventoUrl"] as? String ?? ""
                    let fecha = data["Fecha"] as? String ?? ""

                    guard !nombre.isEmpty else { return nil }
                    return Event(id: doc.documentID, tx1: lugar, tx2: nombre, img1: url, fecha: fecha)
                }

                let source = snapshot?.metadata.isFromCache == true ? "cache" : "server"
                print("🏠 Discover actualizado desde \(source): \(events.count) eventos")
            }
    }
}

private struct ForYouCard: View {
    let event: Event
    let accentCyan: Color
    let cardBackground: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            RemoteEventImage(urlString: event.img1)
                .frame(width: 282, height: 158)
                .clipped()

            VStack(alignment: .leading, spacing: 8) {
                Text(event.tx2.firebaseLineBreaks.uppercased())
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.white)
                    .lineLimit(1)

                HStack(alignment: .bottom, spacing: 12) {
                    VStack(spacing: 0) {
                        Text("SEP")
                            .font(.system(size: 10, weight: .semibold))
                        Text("11")
                            .font(.system(size: 20, weight: .bold))
                        Rectangle()
                            .fill(Color.orange)
                            .frame(width: 24, height: 2)
                    }
                    .foregroundStyle(.white)

                    VStack(alignment: .leading, spacing: 6) {
                        Text((event.fecha.isEmpty ? "viernes • 20:30" : event.fecha).firebaseLineBreaks)
                            .font(.system(size: 12))
                            .foregroundStyle(.white)
                            .lineLimit(1)

                        HStack(spacing: 5) {
                            Image(systemName: "mappin.square.fill")
                                .foregroundStyle(accentCyan)
                            Text((event.tx1.isEmpty ? "México, MX" : event.tx1).firebaseLineBreaks)
                                .lineLimit(1)
                        }
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.white)
                    }

                    Spacer(minLength: 0)

                    Image(systemName: "ellipsis.vertical")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                }
            }
            .padding(10)
        }
        .frame(width: 282)
        .background(cardBackground)
    }
}

private struct TrendingRow: View {
    let event: Event
    let rank: Int
    let cardBackground: Color

    var body: some View {
        HStack(spacing: 0) {
            Text(String(format: "%02d", rank))
                .font(.system(size: 31, weight: .regular))
                .foregroundStyle(.black)
                .overlay {
                    Text(String(format: "%02d", rank))
                        .font(.system(size: 31, weight: .regular))
                        .foregroundStyle(.yellow)
                }
                .frame(width: 58)

            RemoteEventImage(urlString: event.img1)
                .frame(width: 82, height: 64)
                .clipped()

            VStack(alignment: .leading, spacing: 4) {
                Text(event.tx2.firebaseLineBreaks)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.white)
                    .lineLimit(1)

                HStack(spacing: 5) {
                    Image(systemName: "square.grid.2x2")
                        .font(.system(size: 10))
                    Text((event.tx1.isEmpty ? "Evento" : event.tx1).firebaseLineBreaks)
                        .lineLimit(1)
                }
                .font(.system(size: 11))
                .foregroundStyle(.white.opacity(0.8))
            }
            .padding(.horizontal, 10)

            Spacer(minLength: 4)

            Image(systemName: "heart")
                .font(.system(size: 22, weight: .regular))
                .foregroundStyle(.white)
                .padding(.trailing, 14)
        }
        .frame(height: 64)
        .background(cardBackground)
    }
}

private struct LastChanceCard: View {
    let event: Event

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            RemoteEventImage(urlString: event.img1)
                .frame(width: 180, height: 100)
                .clipped()

            Text(event.tx2.firebaseLineBreaks)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.white)
                .lineLimit(1)

            Text((event.fecha.isEmpty ? "vie 11 sep" : event.fecha).firebaseLineBreaks)
                .font(.system(size: 10))
                .foregroundStyle(.white.opacity(0.75))
                .lineLimit(1)
        }
        .frame(width: 180, alignment: .leading)
    }
}

private struct RemoteEventImage: View {
    let urlString: String

    var body: some View {
        OfflineCachedImage(
            urlString: urlString,
            fallbackAsset: "discoverSample",
            contentMode: .fill
        )
    }
}

private extension Event {
    static let previewHomeEvents: [Event] = [
        Event(id: "p1", tx1: "México, MX - Arena México", tx2: "LUCHA LIBRE CMLL", img1: "", fecha: "viernes • 20:30"),
        Event(id: "p2", tx1: "Ciudad de México", tx2: "MENTIRAS ALL STARS", img1: "", fecha: "sábado • 17:00"),
        Event(id: "p3", tx1: "Teatro", tx2: "El Juego Que Todos Jugamos", img1: "", fecha: ""),
        Event(id: "p4", tx1: "Alternativo", tx2: "The Warning", img1: "", fecha: ""),
        Event(id: "p5", tx1: "Pop", tx2: "Mon Laferte", img1: "", fecha: ""),
        Event(id: "p6", tx1: "Ciudad de México", tx2: "Últimos boletos", img1: "", fecha: "vie 11 sep")
    ]
}

#Preview {
    Discover()
}
