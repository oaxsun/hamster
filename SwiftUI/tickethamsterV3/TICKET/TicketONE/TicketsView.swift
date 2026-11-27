import SwiftUI
import UIKit

enum TicketCountIconAsset {
    static let image: UIImage = {
        let raw = """
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
"""
        let cleaned = raw.components(separatedBy: .whitespacesAndNewlines).joined()
        guard let data = Data(base64Encoded: cleaned),
              let image = UIImage(data: data) else {
            return UIImage()
        }
        return image
    }()
}


struct TicketsView: View {
    @Environment(\.presentationMode) private var presentationMode

    @State private var showCodeViewer = false
    @State private var showTransferError = false
    @State private var showHelpError = false

    @StateObject private var eventVM = EventViewModel()
    @StateObject private var ticketsVM = TicketsViewModel()

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    hero
                    eventSummary
                        .padding(.top, -26)

                    purchaseSection
                        .padding(.top, 28)

                    moreOptionsSection
                        .padding(.top, 30)
                        .padding(.bottom, 150)
                }
            }

            floatingActions
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom, 50)
                .zIndex(10)
        }
        .preferredColorScheme(.dark)
        .fullScreenCover(isPresented: $showCodeViewer) {
            CodeViewer(
                pages: $ticketsVM.pages,
                initialIndex: 0
            )
        }
        .fullScreenCover(isPresented: $showTransferError) {
            Error()
        }
        .fullScreenCover(isPresented: $showHelpError) {
            Error()
        }
    }

    private var hero: some View {
        ZStack(alignment: .top) {
            eventHeroImage
                .frame(height: 258)
                .clipped()

            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 42, height: 42)
                        .background(.black.opacity(0.58))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)

                Spacer()

                Button("Ayuda") {
                    showHelpError = true
                }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .frame(height: 42)
                    .background(.black.opacity(0.58))
                    .clipShape(Capsule())
            }
            .padding(.horizontal, 20)
            .padding(.top, 52)
        }
        .ignoresSafeArea(edges: .top)
    }

    private var eventSummary: some View {
        VStack(spacing: 0) {
            GeometryReader { geometry in
                ZStack(alignment: .topLeading) {
                    Color(red: 0.11, green: 0.11, blue: 0.11)

                    VStack(alignment: .leading, spacing: 16) {
                        HStack(alignment: .center, spacing: 12) {
                            Text((eventVM.event?.nombre ?? firstPage?.tx6 ?? "CARGANDO EVENTO…").firebaseLineBreaks)
                                .font(.system(size: 27, weight: .bold))
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.leading)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)

                            Spacer(minLength: 8)
                        }

                        HStack(alignment: .center, spacing: 14) {
                            Text((eventVM.event?.lugar ?? venueText).firebaseLineBreaks)
                                .font(.system(size: 15, weight: .regular))
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)

                            Spacer()

                            HStack(spacing: 7) {
                                Image(uiImage: TicketCountIconAsset.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)

                                Text("x\(max(ticketsVM.pages.count, 1))")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundStyle(.white)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 42)
                    .padding(.bottom, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Text((eventVM.event?.fecha ?? firstPage?.tx7 ?? "CARGANDO FECHA…").firebaseLineBreaks)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.82)
                        .padding(.horizontal, 20)
                        .frame(width: geometry.size.width * 0.60, height: 50, alignment: .leading)
                        .background(Color(red: 0.11, green: 0.11, blue: 0.11))
                        .offset(y: -19)
                }
            }
            .frame(height: 168)

            Button {
                showCodeViewer = true
            } label: {
                HStack(spacing: 10) {
                    Image("scan")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)

                    Text("Ver Boletos")
                        .font(.system(size: 18, weight: .semibold))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(Color(red: 0.04, green: 0.32, blue: 0.90))
            }
            .buttonStyle(.plain)
            .disabled(ticketsVM.isLoading || ticketsVM.pages.isEmpty)
            .opacity((ticketsVM.isLoading || ticketsVM.pages.isEmpty) ? 0.72 : 1)
        }
        .padding(.horizontal, 18)
    }

    private var purchaseSection: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(purchaseTitle)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(.white)

                    Text("x\(max(ticketsVM.pages.count, 1)) boletos")
                        .font(.system(size: 14))
                        .foregroundStyle(.white.opacity(0.72))
                }

                Spacer()

                Image(systemName: "ellipsis.vertical")
                    .font(.system(size: 21, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.top, 4)
            }

            if ticketsVM.isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                        .tint(.white)
                    Spacer()
                }
                .frame(height: 120)
                .background(Color(red: 0.11, green: 0.11, blue: 0.11))
            } else if ticketsVM.pages.isEmpty {
                Text("No hay boletos disponibles")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.white.opacity(0.72))
                    .frame(maxWidth: .infinity, minHeight: 90, alignment: .center)
                    .background(Color(red: 0.11, green: 0.11, blue: 0.11))
            } else {
                VStack(spacing: 10) {
                    ForEach(Array(ticketsVM.pages.enumerated()), id: \.element.id) { _, page in
                        ticketSummaryCard(page)
                    }
                }
            }
        }
        .padding(.horizontal, 18)
    }

    private func ticketSummaryCard(_ page: Page) -> some View {
        VStack(spacing: 0) {
            HStack {
                Text("TICKET")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.white)
                Spacer()
            }
            .padding(.horizontal, 18)
            .frame(height: 50)
            .background(Color(red: 0.12, green: 0.12, blue: 0.12))

            Color.black
                .frame(height: 2.5)

            HStack(alignment: .top, spacing: 12) {
                ticketColumn(title: "SECCIÓN", value: page.tx3, alignment: .leading)
                ticketColumn(title: "FILA", value: page.tx4, alignment: .center)
                ticketColumn(title: "ASIENTO", value: page.tx5, alignment: .trailing)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 22)
            .background(Color(red: 0.12, green: 0.12, blue: 0.12))
        }
    }

    private func ticketColumn(title: String, value: String, alignment: Alignment) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(.white.opacity(0.72))

            Text((value.isEmpty ? "—" : value).firebaseLineBreaks)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, alignment: alignment)
    }

    private var moreOptionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("MÁS OPCIONES")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(.white)

            mapPlaceholder
                .frame(height: 230)
                .clipped()
        }
        .padding(.horizontal, 18)
    }

    private var floatingActions: some View {
        HStack(spacing: 0) {
            optionButton(title: "Mejorar", icon: "arrow.up", isEnabled: false) { }
            optionButton(title: "Transferir", icon: "arrow.up.right", isEnabled: true) {
                showTransferError = true
            }
            optionButton(title: "Vender", icon: "arrow.triangle.2.circlepath", isEnabled: false) { }
        }
        .frame(width: 280, height: 70)
        .background(Color.white)
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.22), radius: 10, x: 0, y: 4)
    }

    private var mapPlaceholder: some View {
        Image("autodromoMap")
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
            .background(Color(red: 0.11, green: 0.11, blue: 0.11))
    }

    private func optionButton(title: String, icon: String, isEnabled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 7) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .regular))

                Text(title)
                    .font(.system(size: 12, weight: .regular))
            }
            .foregroundStyle(isEnabled ? Color.black : Color.gray.opacity(0.55))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
    }

    private var eventHeroImage: some View {
        OfflineCachedImage(
            urlString: eventVM.event?.eventIMG ?? "",
            fallbackAsset: "event2",
            contentMode: .fill
        )
    }

    private var firstPage: Page? {
        ticketsVM.pages.first
    }

    private var venueText: String {
        let place = firstPage?.place.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let city = firstPage?.city.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        if !place.isEmpty && !city.isEmpty { return "\(place) - \(city)" }
        if !place.isEmpty { return place }
        if !city.isEmpty { return city }
        return "CARGANDO LUGAR…"
    }

    private var purchaseTitle: String {
        "Compra #3-51038/MXC"
    }

}

// MARK: - Existing ticket flow, preserved

struct TicketCarouselView: View {
    @Environment(\.presentationMode) private var presentationMode

    @State private var modal3 = false
    @State private var pageIndex = 0
    @State private var selectedIndex: Int? = nil

    private let dotAppearance = UIPageControl.appearance()

    @StateObject private var ticketsVM = TicketsViewModel()

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            contentView
                .padding(.bottom, 120)

            transferButton
        }
        .preferredColorScheme(.dark)
        .fullScreenCover(item: $selectedIndex) { index in
            CodeViewer(
                pages: $ticketsVM.pages,
                initialIndex: index
            )
        }
        .overlay { headerView }
        .frame(maxHeight: .infinity, alignment: .top)
    }

    @ViewBuilder
    private var contentView: some View {
        ZStack {
            if ticketsVM.isLoading {
                VStack {
                    Spacer()
                    ProgressView("Cargando tickets…")
                        .tint(.white)
                        .foregroundStyle(.white)
                        .padding(.bottom, 60)
                }
            } else if ticketsVM.pages.isEmpty {
                VStack {
                    Spacer()
                    Text("No hay tickets para este evento")
                        .foregroundColor(.gray)
                        .padding(.bottom, 60)
                }
            } else {
                ticketsPager
            }
        }
    }

    private var ticketsPager: some View {
        TabView(selection: $pageIndex) {
            ForEach(Array(ticketsVM.pages.enumerated()), id: \.element.id) { index, page in
                VStack {
                    Spacer()
                    PageView(
                        page: page,
                        onOpenCode: {
                            selectedIndex = index
                        }
                    )
                    .padding(.bottom, 30)
                }
                .tag(index)
            }
        }
        .animation(.easeInOut, value: pageIndex)
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .interactive))
        .onAppear {
            dotAppearance.currentPageIndicatorTintColor = .gray
            dotAppearance.pageIndicatorTintColor = UIColor.gray.withAlphaComponent(0.2)
        }
    }

    private var transferButton: some View {
        Button("Transfer") { modal3.toggle() }
            .fullScreenCover(isPresented: $modal3) { Error() }
            .font(.custom("Lexend", size: 16).bold())
            .foregroundColor(.white)
            .padding(25)
            .frame(height: 45)
            .frame(maxWidth: 365)
            .background(Color("nHead"))
            .cornerRadius(2)
            .hoverEffect()
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 48)
    }

    private var headerView: some View {
        VStack(spacing: 0) {
            ZStack {
                Color("nHead")
                    .ignoresSafeArea(edges: .top)

                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "multiply")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    }
                    .buttonStyle(.plain)

                    Spacer()

                    Text("My Tickets")
                        .fontWeight(.bold)
                        .font(.custom("Lexend", size: 18))
                        .foregroundColor(.white)

                    Spacer()

                    Color.clear
                        .frame(width: 20, height: 20)
                }
                .padding(.horizontal, 20)
            }
            .frame(height: 64)

            Spacer()
        }
    }
}

extension Int: Identifiable {
    public var id: Int { self }
}

#Preview {
    TicketsView()
}


