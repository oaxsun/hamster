import SwiftUI

struct CodeView: View {

    @State private var animation = false
    @State private var showRefreshError = false
    @State private var showDetails = false

    let page: Page

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {

                barcodeCard
                    .padding(.horizontal, 24)
                    .padding(.top, 8)

                safeArtwork
                    .frame(height: 255)
                    .clipped()
                    .padding(.horizontal, 34)

                ticketInfoCard
                    .padding(.horizontal, 34)

                Button {
                    showDetails = true
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "info.circle")
                            .font(.system(size: 19, weight: .medium))

                        Text("Información del Boleto")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 18)
                    .frame(height: 48)
                    .overlay(
                        Capsule()
                            .stroke(.white.opacity(0.9), lineWidth: 1.2)
                    )
                }
                .buttonStyle(.plain)
                .padding(.top, 24)
                .padding(.bottom, 18)
            }
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

    private var barcodeCard: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Text("ticketmaster")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.trailing, 10)
            }
            .frame(height: 25)
            .background(Color(red: 0.04, green: 0.32, blue: 0.90))

            ZStack {
                Color.white

                VStack(spacing: 8) {
                    Text("Con capturas de pantalla no se te permitirá el acceso.")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(.gray)

                    ZStack {
                        barcodeImage

                        Rectangle()
                            .frame(width: 10, height: 70)
                            .frame(maxWidth: 290, alignment: animation ? .trailing : .leading)
                            .foregroundStyle(Color(red: 0.04, green: 0.32, blue: 0.90).opacity(0.55))
                            .animation(
                                .linear(duration: 1.5)
                                    .repeatForever(autoreverses: true),
                                value: animation
                            )

                        Rectangle()
                            .frame(width: 3, height: 84)
                            .frame(maxWidth: 286, alignment: animation ? .trailing : .leading)
                            .foregroundStyle(Color(red: 0.04, green: 0.32, blue: 0.90))
                            .animation(
                                .linear(duration: 1.5)
                                    .repeatForever(autoreverses: true),
                                value: animation
                            )

                        Button {
                            showRefreshError = true
                        } label: {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 19, weight: .medium))
                                .foregroundStyle(.black)
                                .frame(width: 34, height: 34)
                        }
                        .buttonStyle(.plain)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .frame(height: 120)
        }
        .alert("Error", isPresented: $showRefreshError) {
            Button("Aceptar", role: .cancel) { }
        } message: {
            Text("A network error has occurred, please try again later.")
        }
    }

    private var safeArtwork: some View {
        Group {
            if let url = URL(string: page.safeUrl),
               !page.safeUrl.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ZStack {
                            Color(red: 0.12, green: 0.12, blue: 0.12)
                            ProgressView().tint(.white)
                        }
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        fallbackSafeArtwork
                    @unknown default:
                        fallbackSafeArtwork
                    }
                }
            } else {
                fallbackSafeArtwork
            }
        }
    }

    private var fallbackSafeArtwork: some View {
        Image("safeSample")
            .resizable()
            .scaledToFill()
    }

    private var ticketInfoCard: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 3) {
                Text(page.tx1.firebaseLineBreaks)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)

                Text("Admisión General")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.white.opacity(0.9))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 18)
            .padding(.vertical, 14)
            .background(Color(red: 0.24, green: 0.24, blue: 0.24))

            Divider()
                .overlay(.white.opacity(0.35))

            HStack(spacing: 0) {
                infoColumn(title: "SECCIÓN", value: page.tx3)
                infoColumn(title: "FILA", value: page.tx4)
                infoColumn(title: "ASIENTO", value: page.tx5)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 14)
            .background(Color(red: 0.24, green: 0.24, blue: 0.24))

            Text(page.acceso.firebaseLineBreaks.isEmpty ? "ACCESO" : page.acceso.firebaseLineBreaks)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity)
                .frame(height: 42)
                .background(Color.white)

            Button { } label: {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle")
                        .font(.system(size: 17, weight: .medium))
                    Text("Ver en Wallet")
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundStyle(.white)
            }
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity)
            .frame(height: 46)
            .background(Color.black)
        }
    }

    private func infoColumn(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(.white.opacity(0.75))

            Text((value.isEmpty ? "—" : value).firebaseLineBreaks)
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(.white)
                .lineLimit(2)
                .minimumScaleFactor(0.75)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var barcodeImage: some View {
        Group {
            if let url = URL(string: page.barcodeUrl),
               !page.barcodeUrl.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .tint(.black)
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
        .frame(height: 72)
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
