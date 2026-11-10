import SwiftUI

struct ContentView: View {
    var body: some View {
        if UIDevice.current.userInterfaceIdiom == .pad {
            TabletLayout()
        } else {
            PhoneLayout()
        }
    }
}

struct RoomRow: View {
    let room: Room

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(room.name).font(.headline)
            Text("Holds \(room.capacity)").font(.subheadline).foregroundStyle(.secondary)
        }
    }
}

struct ScheduleView: View {
    let room: Room?

    var body: some View {
        if let room {
            List(Session.forRoom(room.id)) { session in
                HStack {
                    Text(session.time).monospacedDigit().foregroundStyle(.secondary)
                    Text(session.title)
                }
            }
            .navigationTitle(room.name)
        } else {
            Text("Pick a room").foregroundStyle(.secondary)
        }
    }
}
