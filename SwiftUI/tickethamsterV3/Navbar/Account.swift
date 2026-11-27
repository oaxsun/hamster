import SwiftUI

struct Account: View {
    @State private var locationContent = true
    @State private var notifications = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.055, green: 0.055, blue: 0.055).ignoresSafeArea()

                ScrollView(showsIndicators: true) {
                    VStack(alignment: .leading, spacing: 26) {
                        profileHeader

                        accountSection(title: "Personalización") {
                            navigationRow(icon: "envelope", title: "Mis notificaciones")
                            navigationRow(icon: "heart", title: "Favoritos")
                            navigationRow(icon: "mappin.and.ellipse", title: "Ubicación")
                        }

                        accountSection(title: "Permisos") {
                            toggleRow(
                                icon: "location.fill",
                                title: "Contenido Basado en tu Ubicación",
                                isOn: $locationContent
                            )
                            toggleRow(
                                icon: "bell",
                                title: "Recibir Notificaciones",
                                isOn: $notifications
                            )
                        }

                        accountSection(title: "Información personal") {
                            navigationRow(icon: "person.badge.key", title: "Editar predeterminado")
                            navigationRow(icon: "checkmark.shield", title: "Seguridad")
                            navigationRow(icon: "creditcard", title: "Métodos de pago")
                        }

                        accountSection(title: "Ayuda y orientación") {
                            navigationRow(icon: "questionmark.circle", title: "¿Necesitas ayuda?")
                            navigationRow(icon: "eye", title: "Privacidad")
                            navigationRow(icon: "doc.text", title: "Legal")
                        }

                        VStack(spacing: 0) {
                            navigationRow(icon: "rectangle.portrait.and.arrow.right", title: "Desconectar")
                        }

                        Spacer(minLength: 82)
                    }
                    .padding(.horizontal, 17)
                    .padding(.top, 14)
                }
            }
            .preferredColorScheme(.dark)
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private var profileHeader: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle()
                    .stroke(Color.blue, lineWidth: 3)
                    .frame(width: 62, height: 62)

                Text("LE")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text("Luis Eduardo Hernandez Jimenez")
                    .font(.system(size: 19, weight: .semibold))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.82)

                Text("eddy.hjimenez@gmail.com")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(.white.opacity(0.86))
            }

            Spacer(minLength: 0)
        }
        .padding(.top, 4)
    }

    @ViewBuilder
    private func accountSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 11) {
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.white)

            VStack(spacing: 0) {
                content()
            }
        }
    }

    private func navigationRow(icon: String, title: String) -> some View {
        NavigationLink {
            Error()
        } label: {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(.white)
                    .frame(width: 19)

                Text(title)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(.white)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 16)
            .frame(height: 45)
            .background(Color(red: 0.13, green: 0.13, blue: 0.13))
            .overlay(alignment: .bottom) {
                Rectangle()
                    .fill(Color.black.opacity(0.75))
                    .frame(height: 1)
            }
        }
        .buttonStyle(.plain)
    }

    private func toggleRow(icon: String, title: String, isOn: Binding<Bool>) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(.white)
                .frame(width: 19)

            Text(title)
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            Spacer(minLength: 8)

            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(.blue)
                .scaleEffect(0.9)
        }
        .padding(.horizontal, 16)
        .frame(height: 52)
        .background(Color(red: 0.13, green: 0.13, blue: 0.13))
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.black.opacity(0.75))
                .frame(height: 1)
        }
    }
}

#Preview {
    Account()
}
