import SwiftUI

struct ContentView: View {
    @StateObject private var store = GigStore()

    var body: some View {
        GeometryReader { proxy in
            content(width: proxy.size.width)
        }
    }

    private func content(width: CGFloat) -> some View {
        let wide = width > 500
        return NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                List(store.gigs) { gig in
                    NavigationLink(value: gig.id) {
                        GigRow(gig: gig, width: width - 64)
                    }
                }
                Button {
                    store.addGig()
                } label: {
                    Image(systemName: "plus")
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                        .frame(width: 56, height: 56)
                        .background(Circle().fill(Color.indigo))
                        .shadow(radius: 4, y: 2)
                }
                .accessibilityLabel("Add gig")
                .padding(.trailing, 20)
                .padding(.bottom, 20)
            }
            .navigationTitle("Gig Log")
            .navigationDestination(for: Gig.ID.self) { id in
                DetailView(store: store, gigID: id, wide: wide)
            }
        }
    }
}

struct GigRow: View {
    let gig: Gig
    let width: CGFloat

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(gig.title).font(.headline)
            Text("\(gig.venue) - \(gig.date)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(width: width, alignment: .leading)
    }
}
