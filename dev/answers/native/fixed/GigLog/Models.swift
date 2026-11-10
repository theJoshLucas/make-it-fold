import SwiftUI

struct Gig: Identifiable, Hashable {
    let id: UUID
    var title: String
    var venue: String
    var date: String
    var loadIn: String
    var notes: String

    init(title: String, venue: String, date: String, loadIn: String = "", notes: String = "") {
        self.id = UUID()
        self.title = title
        self.venue = venue
        self.date = date
        self.loadIn = loadIn
        self.notes = notes
    }
}

final class GigStore: ObservableObject {
    @Published var gigs: [Gig] = [
        Gig(title: "Friday at the Grange", venue: "Grange Hall", date: "Fri, Dec 5", loadIn: "6:30 PM", notes: "Two sets, 45 minutes each."),
        Gig(title: "Spring recital", venue: "Lincoln Auditorium", date: "Sat, Dec 13", loadIn: "1:00 PM"),
        Gig(title: "Wedding, Hall B", venue: "Riverside Banquet", date: "Sat, Dec 20", loadIn: "3:15 PM", notes: "First dance is a slow version of September.")
    ]

    func addGig() {
        gigs.insert(Gig(title: "New gig", venue: "TBD", date: "Date TBD"), at: 0)
    }

    func rename(_ id: Gig.ID, to title: String) {
        guard let i = gigs.firstIndex(where: { $0.id == id }), !title.isEmpty else { return }
        gigs[i].title = title
    }

    func setNotes(_ id: Gig.ID, _ notes: String) {
        guard let i = gigs.firstIndex(where: { $0.id == id }) else { return }
        gigs[i].notes = notes
    }

    func setLoadIn(_ id: Gig.ID, _ value: String) {
        guard let i = gigs.firstIndex(where: { $0.id == id }) else { return }
        gigs[i].loadIn = value
    }
}
