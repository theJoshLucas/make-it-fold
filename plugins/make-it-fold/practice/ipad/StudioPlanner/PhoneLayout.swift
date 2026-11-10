import SwiftUI

struct PhoneLayout: View {
    @State private var path: [Room] = []

    var body: some View {
        NavigationStack(path: $path) {
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
