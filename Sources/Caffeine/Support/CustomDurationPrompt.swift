import AppKit
import Foundation

enum CustomDurationPrompt {
    static func requestMinutes(strings: AppStrings) -> Int? {
        let alert = NSAlert()
        alert.messageText = strings.customDurationTitle
        alert.informativeText = strings.customDurationMessage
        alert.alertStyle = .informational
        alert.addButton(withTitle: strings.start)
        alert.addButton(withTitle: strings.cancel)

        let field = NSTextField(frame: NSRect(x: 0, y: 0, width: 180, height: 24))
        field.placeholderString = strings.customDurationPlaceholder
        field.stringValue = ""
        alert.accessoryView = field

        let response = alert.runModal()
        guard response == .alertFirstButtonReturn else { return nil }

        let minutes = Int(field.stringValue.trimmingCharacters(in: .whitespacesAndNewlines))
        guard let minutes, minutes > 0 else { return nil }
        return minutes
    }
}
