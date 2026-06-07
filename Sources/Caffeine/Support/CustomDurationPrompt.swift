import AppKit
import Foundation

enum CustomDurationPrompt {
    static func requestMinutes() -> Int? {
        let alert = NSAlert()
        alert.messageText = "Свое значение"
        alert.informativeText = "Введите длительность в минутах."
        alert.alertStyle = .informational
        alert.addButton(withTitle: "Запустить")
        alert.addButton(withTitle: "Отмена")

        let field = NSTextField(frame: NSRect(x: 0, y: 0, width: 180, height: 24))
        field.placeholderString = "Например, 45"
        field.stringValue = ""
        alert.accessoryView = field

        let response = alert.runModal()
        guard response == .alertFirstButtonReturn else { return nil }

        let minutes = Int(field.stringValue.trimmingCharacters(in: .whitespacesAndNewlines))
        guard let minutes, minutes > 0 else { return nil }
        return minutes
    }
}
