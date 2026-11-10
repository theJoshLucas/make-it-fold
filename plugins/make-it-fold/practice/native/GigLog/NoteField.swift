import SwiftUI
import UIKit

/// A single-line UIKit field that dismisses the keyboard once the value is complete.
struct NoteField: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String
    var maxLength: Int

    func makeUIView(context: Context) -> UITextField {
        let field = UITextField()
        field.placeholder = placeholder
        field.borderStyle = .roundedRect
        field.autocorrectionType = .no
        field.addTarget(context.coordinator, action: #selector(Coordinator.changed(_:)), for: .editingChanged)
        return field
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
        if text.count >= maxLength {
            uiView.resignFirstResponder()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }

    final class Coordinator: NSObject {
        var text: Binding<String>

        init(text: Binding<String>) {
            self.text = text
        }

        @objc func changed(_ sender: UITextField) {
            text.wrappedValue = sender.text ?? ""
        }
    }
}
