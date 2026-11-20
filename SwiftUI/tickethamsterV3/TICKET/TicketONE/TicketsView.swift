import SwiftUI

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
                                .lineLimit(2)

                            Spacer(minLength: 8)
                        }

                        HStack(alignment: .center, spacing: 14) {
                            Text((eventVM.event?.lugar ?? venueText).firebaseLineBreaks)
                                .font(.system(size: 15, weight: .regular))
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)

                            Spacer()

                            HStack(spacing: 6) {
                                Image(systemName: "ticket.fill")
                                    .font(.system(size: 21, weight: .medium))
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
            .frame(height: 142)

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

    @ViewBuilder
    private var eventHeroImage: some View {
        if let urlString = eventVM.event?.eventIMG,
           let url = URL(string: urlString),
           !urlString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        Color(red: 0.13, green: 0.13, blue: 0.13)
                        ProgressView().tint(.white)
                    }
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    fallbackHero
                @unknown default:
                    fallbackHero
                }
            }
        } else {
            fallbackHero
        }
    }

    private var fallbackHero: some View {
        Image("event2")
            .resizable()
            .scaledToFill()
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
