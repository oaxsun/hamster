import SwiftUI

struct Events: View {
    @State private var currentTab: Int = 0

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                header
                tabs

                TabView(selection: $currentTab) {
                    EventsUp()
                        .tag(0)

                    EventsP()
                        .tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
        }
        .preferredColorScheme(.dark)
    }

    private var header: some View {
        ZStack {
            Color(red: 0.055, green: 0.055, blue: 0.055)

            HStack(spacing: 8) {
                Spacer()

                Text("Mis Eventos")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)

                Image("country")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)

                Spacer()
            }

            HStack {
                Spacer()

                Button("Ayuda") { }
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.trailing, 24)
            }
        }
        .frame(height: 92)
    }

    private var tabs: some View {
        HStack(spacing: 0) {
            tabButton(title: "PRÓXIMOS (1)", index: 0)
            tabButton(title: "PASADOS (0)", index: 1)
        }
        .background(Color(red: 0.055, green: 0.055, blue: 0.055))
        .frame(height: 66)
    }

    private func tabButton(title: String, index: Int) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                currentTab = index
            }
        } label: {
            VStack(spacing: 14) {
                Spacer()

                Text(title)
                    .font(.system(size: 15, weight: currentTab == index ? .semibold : .regular))
                    .foregroundStyle(currentTab == index ? .white : .white.opacity(0.72))

                Rectangle()
                    .fill(currentTab == index ? Color.white : Color.clear)
                    .frame(height: 4)
            }
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    Events()
}
