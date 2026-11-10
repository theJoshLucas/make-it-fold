import SwiftUI

struct DetailView: View {
    @ObservedObject var store: GigStore
    let gigID: Gig.ID
    let wide: Bool

    @State private var renaming = false
    @State private var newTitle = ""

    private var gig: Gig? { store.gigs.first { $0.id == gigID } }

    var body: some View {
        VStack {
            if let gig {
                if wide {
                    WideDetail(store: store, gig: gig)
                } else {
                    NarrowDetail(store: store, gig: gig)
                }
            }
        }
        .ignoresSafeArea()
        .background(Color(.systemGroupedBackground))
        .toolbar {
            ToolbarItem(placement: .principal) {
                Button {
                    newTitle = gig?.title ?? ""
                    renaming = true
                } label: {
                    VStack(spacing: 0) {
                        Text(gig?.title ?? "Gig").font(.headline)
                        Text("Tap to rename").font(.caption2).foregroundStyle(.secondary)
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .alert("Rename gig", isPresented: $renaming) {
            TextField("Title", text: $newTitle)
            Button("Save") { store.rename(gigID, to: newTitle) }
            Button("Cancel", role: .cancel) {}
        }
    }
}

struct LoadInRow: View {
    @ObservedObject var store: GigStore
    let gig: Gig

    var body: some View {
        HStack {
            Text("Load-in").foregroundStyle(.secondary)
            NoteField(
                text: Binding(
                    get: { gig.loadIn },
                    set: { store.setLoadIn(gig.id, $0) }
                ),
                placeholder: "6:30 PM",
                maxLength: 8
            )
            .frame(height: 34)
        }
    }
}

struct NarrowDetail: View {
    @ObservedObject var store: GigStore
    let gig: Gig
    @State private var draft = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(gig.venue).font(.title3.bold())
            Text(gig.date).foregroundStyle(.secondary)
            LoadInRow(store: store, gig: gig)
            Text("Notes").font(.footnote).foregroundStyle(.secondary)
            TextEditor(text: $draft)
                .frame(minHeight: 180)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary.opacity(0.4)))
            Button("Save note") {
                store.setNotes(gig.id, draft)
            }
            .buttonStyle(.borderedProminent)
            Spacer()
        }
        .padding()
        .onAppear { draft = gig.notes }
    }
}

struct WideDetail: View {
    @ObservedObject var store: GigStore
    let gig: Gig
    @State private var draft = ""

    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            VStack(alignment: .leading, spacing: 12) {
                Text(gig.venue).font(.title2.bold())
                Text(gig.date).foregroundStyle(.secondary)
                LoadInRow(store: store, gig: gig)
                Spacer()
            }
            .frame(maxWidth: 260)
            VStack(alignment: .leading, spacing: 12) {
                Text("Notes").font(.footnote).foregroundStyle(.secondary)
                TextEditor(text: $draft)
                    .frame(minHeight: 260)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary.opacity(0.4)))
                Button("Save note") {
                    store.setNotes(gig.id, draft)
                }
                .buttonStyle(.borderedProminent)
                Spacer()
            }
        }
        .padding()
        .onAppear { draft = gig.notes }
    }
}
