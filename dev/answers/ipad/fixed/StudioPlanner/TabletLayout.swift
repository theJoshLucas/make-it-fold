import SwiftUI

struct TabletLayout: View {
    @Binding var selectedRoomID: Room.ID?

    private var selectedRoom: Room? {
        Room.all.first { $0.id == selectedRoomID }
    }

    var body: some View {
        GeometryReader { proxy in
            layout(landscape: proxy.size.width > proxy.size.height)
        }
    }

    @ViewBuilder
    private func layout(landscape: Bool) -> some View {
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
