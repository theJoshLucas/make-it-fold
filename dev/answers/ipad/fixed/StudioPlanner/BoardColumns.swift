import SwiftUI

struct ThreeColumnBoard: View {
    @Binding var selection: Room.ID?

    private var room: Room? {
        Room.all.first { $0.id == selection }
    }

    var body: some View {
        HStack(spacing: 0) {
            List(Room.all, selection: $selection) { room in
                RoomRow(room: room)
            }
            .frame(minWidth: 180, idealWidth: 300, maxWidth: 300)

            Divider()

            NavigationStack {
                ScheduleView(room: room)
            }
            .frame(minWidth: 240, maxWidth: .infinity)

            Divider()

            RoomPanel(room: room)
                .frame(minWidth: 180, idealWidth: 320, maxWidth: 320)
        }
    }
}

struct RoomPanel: View {
    let room: Room?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let room {
                Text(room.name).font(.title2.bold())
                Text("Capacity: \(room.capacity)")
                Text(room.note).foregroundStyle(.secondary)
            } else {
                Text("No room selected").foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
