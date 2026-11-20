import SwiftUI

struct CodeView: View {

    @State private var animation = false
    @State private var showRefreshError = false
    @State private var showDetails = false

    let page: Page

    var body: some View {
        VStack(spacing: 0) {
            dynamicTicket
                .padding(.horizontal, 0)

            bottomActions
                .padding(.top, 28)
                .padding(.horizontal, 36)
                .padding(.bottom, 14)
        }
        .background(Color.black)
        .fullScreenCover(isPresented: $showDetails) {
            Details(page: page)
        }
        .onAppear {
            restartScanAnimation()
        }
        .onDisappear {
            animation = false
        }
    }

    // MARK: - Ticket dinámico completo

    private var dynamicTicket: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let infoWidth = width * 0.82

            ZStack(alignment: .top) {
                safeBackground
                    .frame(width: width, height: geometry.size.height)
                    .clipped()

                VStack(spacing: 0) {
                    ticketmasterBar
                    barcodeCard
                        .padding(.horizontal, width * 0.085)
                        .padding(.top, 34)

                    Spacer()
                }

                ticketInfoCard
                    .frame(width: infoWidth)
                    .frame(maxHeight: .infinity, alignment: .bottomLeading)
            }
        }
        .frame(height: 665)
    }

    private var ticketmasterBar: some View {
        ZStack {
            Color(red: 0.035, green: 0.31, blue: 0.90)

            Text("ticketmaster")
                .font(.system(size: 13, weight: .semibold))
                .italic()
                .foregroundStyle(.white)
        }
        .frame(height: 26)
    }

    private var barcodeCard: some View {
        ZStack {
            Color.white

            VStack(spacing: 10) {
                HStack(spacing: 8) {
                    Spacer()

                    Text("Screenshots won’t get you in.")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.black)

                    Button {
                        showRefreshError = true
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(.black)
                    }
                    .buttonStyle(.plain)

                    Spacer()
                }

                ZStack {
                    Color(red: 0.86, green: 0.86, blue: 0.86)

                    barcodeImage
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)

                    Rectangle()
                        .frame(width: 4, height: 88)
                        .frame(maxWidth: .infinity, alignment: animation ? .trailing : .leading)
                        .foregroundStyle(Color(red: 0.12, green: 0.56, blue: 0.98))
                        .animation(
                            .linear(duration: 1.5)
                                .repeatForever(autoreverses: true),
                            value: animation
                        )
                }
                .frame(height: 94)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 14)
        }
        .frame(height: 142)
        .alert("Error", isPresented: $showRefreshError) {
            Button("Aceptar", role: .cancel) { }
        } message: {
            Text("A network error has occurred, please try again later.")
        }
    }

    // MARK: - Bloque inferior del ticket

    private var ticketInfoCard: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 5) {
                Text(page.tx1.firebaseLineBreaks)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)

                Text("Admisión General")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.white.opacity(0.88))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 22)
            .padding(.top, 18)
            .padding(.bottom, 14)

            Rectangle()
                .fill(.white.opacity(0.48))
                .frame(height: 1)
                .padding(.horizontal, 22)

            HStack(spacing: 0) {
                infoColumn(title: "SECCIÓN", value: page.tx3, alignment: .leading)
                infoColumn(title: "FILA", value: page.tx4, alignment: .center)
                infoColumn(title: "ASIENTO", value: page.tx5, alignment: .trailing)
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 15)

            Text(page.acceso.firebaseLineBreaks.isEmpty ? "ACCESO" : page.acceso.firebaseLineBreaks)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity)
                .frame(height: 46)
                .background(Color.white)
                .padding(.horizontal, 22)
                .padding(.bottom, 14)
        }
        .background(Color(red: 0.12, green: 0.12, blue: 0.12))
    }

    private func infoColumn(title: String, value: String, alignment: Alignment) -> some View {
        VStack(alignment: alignment == .trailing ? .trailing : .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(.white.opacity(0.76))

            Text((value.isEmpty ? "—" : value).firebaseLineBreaks)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(.white)
                .lineLimit(2)
                .minimumScaleFactor(0.72)
        }
        .frame(maxWidth: .infinity, alignment: alignment)
    }

    // MARK: - Acciones debajo del ticket

    private var bottomActions: some View {
        HStack(alignment: .center) {
            Button { } label: {
                Text("Ver en Wallet")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .buttonStyle(.plain)

            Spacer()

            Button {
                showDetails = true
            } label: {
                HStack(spacing: 8) {
                    Circle()
                        .fill(.white)
                        .frame(width: 28, height: 28)
                        .overlay(
                            Image(systemName: "info")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(.black)
                        )

                    Text("Información\ndel Boleto")
                        .font(.system(size: 12, weight: .semibold))
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.white)
                }
                .padding(.horizontal, 10)
                .frame(height: 46)
                .overlay(
                    Capsule()
                        .stroke(.white, lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - SafeIMG como fondo

    @ViewBuilder
    private var safeBackground: some View {
        if let url = URL(string: page.safeUrl),
           !page.safeUrl.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        Color(red: 0.68, green: 0.66, blue: 0.66)
                        ProgressView().tint(.white)
                    }
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    fallbackSafeBackground
                @unknown default:
                    fallbackSafeBackground
                }
            }
        } else {
            fallbackSafeBackground
        }
    }

    private var fallbackSafeBackground: some View {
        Image("safeSample")
            .resizable()
            .scaledToFill()
    }

    // MARK: - Barcode

    @ViewBuilder
    private var barcodeImage: some View {
        if let url = URL(string: page.barcodeUrl),
           !page.barcodeUrl.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView().tint(.black)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                case .failure:
                    fallbackBarcode
                @unknown default:
                    fallbackBarcode
                }
            }
        } else {
            fallbackBarcode
        }
    }

    private var fallbackBarcode: some View {
        Image("codeSample")
            .resizable()
            .scaledToFit()
    }

    private func restartScanAnimation() {
        animation = false
        DispatchQueue.main.async {
            animation = true
        }
    }
}

#Preview {
    CodeView(page: Page.samplePage)
}
