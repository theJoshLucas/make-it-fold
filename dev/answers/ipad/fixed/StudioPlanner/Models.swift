import Foundation

struct Room: Identifiable, Hashable {
    let id: Int
    let name: String
    let capacity: Int
    let note: String

    static let all: [Room] = [
        Room(id: 1, name: "Live Room A", capacity: 8, note: "Drum kit and two amp stations."),
        Room(id: 2, name: "Vocal Booth", capacity: 2, note: "Treated booth with a single mic."),
        Room(id: 3, name: "Control Room", capacity: 5, note: "Mixing desk and nearfield monitors."),
        Room(id: 4, name: "Rehearsal Hall", capacity: 14, note: "Open floor, piano against the east wall.")
    ]
}

struct Session: Identifiable {
    let id: Int
    let roomID: Int
    let time: String
    let title: String

    static let all: [Session] = [
        Session(id: 1, roomID: 1, time: "9:00 AM", title: "Drum tracking"),
        Session(id: 2, roomID: 1, time: "1:00 PM", title: "Guitar overdubs"),
        Session(id: 3, roomID: 2, time: "10:30 AM", title: "Lead vocal takes"),
        Session(id: 4, roomID: 3, time: "11:00 AM", title: "Rough mix review"),
        Session(id: 5, roomID: 3, time: "3:00 PM", title: "Mastering prep"),
        Session(id: 6, roomID: 4, time: "6:00 PM", title: "Band rehearsal")
    ]

    static func forRoom(_ roomID: Int) -> [Session] {
        all.filter { $0.roomID == roomID }
    }
}
