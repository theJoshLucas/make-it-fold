import SwiftUI

struct TabletLayout: View {
    @State private var selectedRoomID: Room.ID? = Room.all.first?.id

    private var landscape: Bool {
        UIScreen.main.bounds.width > UIScreen.main.bounds.height
    }

    private var selectedRoom: Room? {
        Room.all.first { $0.id == selectedRoomID }
    }

    var body: some View {
        if landscape {
            ThreeColumnBoard(selection: $selectedRoomID)
        } else {
            NavigationSplitView {
                List(Room.all, selection: $selectedRoomID) { room in
                    RoomRow(room: room)
                }
                .navigationTitle("Rooms")
            } detail: {
                ScheduleView(room: selectedRoom)
            }
        }
    }
}
