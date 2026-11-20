import SwiftUI

struct ContentView: View {
    @StateObject private var store = GigStore()
    // The open gig lives above the layout switch, so it survives a fold.
    @State private var selection: Gig.ID?
    @Environment(\.horizontalSizeClass) private var widthClass
    @Environment(\.verticalSizeClass) private var heightClass

    var body: some View {
        GeometryReader { proxy in
            // Regular width AND regular height: the Duo's inner display (and tablets). An ordinary
            // iPhone, even a large one in landscape, keeps the one-pane layout it always had.
            if widthClass == .regular && heightClass == .regular {
                twoPanes(width: proxy.size.width)
            } else {
                onePane(width: proxy.size.width)
            }
        }
    }

    // Outer display and ordinary iPhones: the list, pushing to the open gig.
    private func onePane(width: CGFloat) -> some View {
        NavigationStack(path: Binding(get: { selection.map { [$0] } ?? [] }, set: { selection = $0.last })) {
            gigList(width: width, pushes: true)
                .navigationDestination(for: Gig.ID.self) { id in
                    DetailView(store: store, gigID: id, wide: width > 500)
                }
        }
    }

    // Inner display: the list on the leading side, the open gig beside it.
    private func twoPanes(width: CGFloat) -> some View {
        let listWidth = min(340, max(280, width * 0.36))
        // With nothing picked yet, the detail pane shows the first gig instead of sitting empty.
        // It is only shown, not picked, so folding to the outer display still lands on the list.
        let picked = selection.flatMap { id in store.gigs.contains(where: { $0.id == id }) ? id : nil }
        let shown = picked ?? store.gigs.first?.id
        return HStack(spacing: 0) {
            NavigationStack {
                gigList(width: listWidth, pushes: false, highlighted: shown)
            }
            .frame(width: listWidth)
            Divider()
            NavigationStack {
                if let id = shown {
                    DetailView(store: store, gigID: id, wide: width - listWidth > 500)
                        .id(id)
                } else {
                    ContentUnavailableView("No gig selected", systemImage: "music.note.list")
                }
            }
        }
    }

    private func gigList(width: CGFloat, pushes: Bool, highlighted: Gig.ID? = nil) -> some View {
        ZStack(alignment: .bottomTrailing) {
            List(store.gigs) { gig in
                if pushes {
                    NavigationLink(value: gig.id) {
                        GigRow(gig: gig, width: width - 64)
                    }
                } else {
                    Button {
                        selection = gig.id
                    } label: {
                        GigRow(gig: gig, width: width - 64)
                    }
                    .buttonStyle(.plain)
                    .listRowBackground(highlighted == gig.id ? Color.indigo.opacity(0.14) : nil)
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
        .frame(width: max(width, 100), alignment: .leading)
    }
}
