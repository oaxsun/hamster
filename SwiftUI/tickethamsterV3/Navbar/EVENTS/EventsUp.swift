import SwiftUI

struct EventsUp: View {
    @State private var showTickets = false
    @StateObject private var eventVM = EventViewModel()

    var body: some View {
        ScrollView(showsIndicators: false) {
            Button {
                showTickets = true
            } label: {
                eventCard
            }
            .buttonStyle(.plain)
            .fullScreenCover(isPresented: $showTickets) {
                TicketsView()
            }
            .padding(.horizontal, 18)
            .padding(.top, 10)
            .padding(.bottom, 28)
        }
        .background(Color.black)
    }

    private var eventCard: some View {
        VStack(spacing: 0) {
            eventImage
                .frame(height: 212)
                .clipped()

            GeometryReader { geometry in
                ZStack(alignment: .topLeading) {
                    Color(red: 0.115, green: 0.115, blue: 0.115)

                    VStack(alignment: .leading, spacing: 16) {
                        Text((eventVM.event?.nombre ?? "CARGANDO NOMBRE…").firebaseLineBreaks)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)

                        Rectangle()
                            .fill(Color(red: 0.55, green: 0.47, blue: 0.46))
                            .frame(width: 98, height: 5)

                        Text((eventVM.event?.lugar ?? "CARGANDO LUGAR…").firebaseLineBreaks)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom, 4)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 42)
                    .padding(.bottom, 24)

                    Text((eventVM.event?.fecha ?? "CARGANDO FECHA…").firebaseLineBreaks)
                        .font(.system(size: 12.5, weight: .bold))
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                        .frame(width: geometry.size.width * 0.56, height: 44, alignment: .leading)
                        .background(Color(red: 0.115, green: 0.115, blue: 0.115))
                        .offset(y: -16)
                }
            }
            .frame(minHeight: 176)
        }
        .background(Color(red: 0.115, green: 0.115, blue: 0.115))
    }

    private var eventImage: some View {
        OfflineCachedImage(
            urlString: eventVM.event?.eventIMG ?? "",
            fallbackAsset: "event2",
            contentMode: .fill
        )
    }
}

#Preview {
    EventsUp()
}
