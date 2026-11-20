import SwiftUI

struct CodeViewer: View {

    @Environment(\.presentationMode) private var presentationMode

    @Binding var pages: [Page]
    private let initialIndex: Int
    @State private var codeIndex: Int = 0

    init(pages: Binding<[Page]>, initialIndex: Int = 0) {
        self._pages = pages
        self.initialIndex = initialIndex
        _codeIndex = State(initialValue: initialIndex)
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                header

                TabView(selection: $codeIndex) {
                    ForEach(Array(pages.enumerated()), id: \.element.id) { index, page in
                        CodeView(page: page)
                            .tag(index)
                    }
                }
                .id(initialIndex)
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: codeIndex)

                Text("\(safeDisplayIndex) de \(max(pages.count, 1))")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.vertical, 8)
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            syncToInitialIndex()
        }
        .onChange(of: pages.count) { _ in
            syncToInitialIndex()
        }
    }

    private var header: some View {
        ZStack {
            if let page = currentPage {
                VStack(alignment: .center, spacing: 4) {
                    Text(page.tx7.firebaseLineBreaks)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                        .minimumScaleFactor(0.72)

                    Text(venueLine(for: page))
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                        .minimumScaleFactor(0.72)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal, 72)
            }

            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)

                Spacer()
            }
        }
        .padding(.horizontal, 18)
        .padding(.top, 8)
        .padding(.bottom, 8)
        .background(Color.black)
    }

    private var safeDisplayIndex: Int {
        guard !pages.isEmpty else { return 0 }
        return min(max(codeIndex + 1, 1), pages.count)
    }

    private var currentPage: Page? {
        guard !pages.isEmpty else { return nil }
        let safeIndex = min(max(codeIndex, 0), pages.count - 1)
        return pages[safeIndex]
    }

    private func venueLine(for page: Page) -> String {
        let place = page.place.trimmingCharacters(in: .whitespacesAndNewlines)
        let city = page.city.trimmingCharacters(in: .whitespacesAndNewlines)

        if !place.isEmpty && !city.isEmpty {
            return "\(place) • \(city)".firebaseLineBreaks
        }
        if !place.isEmpty { return place.firebaseLineBreaks }
        if !city.isEmpty { return city.firebaseLineBreaks }
        return page.tx6.firebaseLineBreaks
    }

    private func syncToInitialIndex() {
        guard !pages.isEmpty else {
            codeIndex = 0
            return
        }
        codeIndex = min(max(initialIndex, 0), pages.count - 1)
    }
}

#Preview {
    StatefulPreviewWrapper(Page.samplePages) { pages in
        CodeViewer(pages: pages, initialIndex: 0)
    }
}

struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State var value: Value
    let content: (Binding<Value>) -> Content

    init(_ value: Value, content: @escaping (Binding<Value>) -> Content) {
        _value = State(initialValue: value)
        self.content = content
    }

    var body: some View {
        content($value)
    }
}
