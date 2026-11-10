import SwiftUI

struct PhoneLayout: View {
    @Binding var selectedRoomID: Room.ID?

    private var path: Binding<[Room]> {
        Binding(
            get: { Room.all.filter { $0.id == selectedRoomID } },
            set: { selectedRoomID = $0.last?.id }
        )
    }

    var body: some View {
        NavigationStack(path: path) {
            List(Room.all) { room in
                NavigationLink(value: room) {
                    RoomRow(room: room)
                }
            }
            .navigationTitle("Rooms")
            .navigationDestination(for: Room.self) { room in
                ScheduleView(room: room)
            }
        }
    }
}
