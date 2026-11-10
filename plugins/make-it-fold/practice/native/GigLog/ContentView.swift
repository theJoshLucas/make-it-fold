import SwiftUI

struct ContentView: View {
    @StateObject private var store = GigStore()

    private var screenWidth: CGFloat { UIScreen.main.bounds.width }
    private var wide: Bool { screenWidth > 500 }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                List(store.gigs) { gig in
                    NavigationLink(value: gig.id) {
                        GigRow(gig: gig, width: screenWidth - 64)
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
                .padding(.bottom, 92)
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
