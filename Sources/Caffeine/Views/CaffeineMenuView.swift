import SwiftUI

struct CaffeineMenuView: View {
    @ObservedObject var controller: CaffeineController

    var body: some View {
        if controller.isActive {
            Text("Активен: \(DurationFormatter.short(controller.remainingSeconds))")
            Button("Деактивировать") {
                controller.deactivate()
            }
            Divider()
        } else {
            Text("Не активен")
            Divider()
        }

        ForEach(CaffeineDuration.presets) { duration in
            Button(duration.title) {
                controller.activate(for: duration.seconds)
            }
        }

        Button("Свое значение...") {
            if let minutes = CustomDurationPrompt.requestMinutes() {
                controller.activate(for: TimeInterval(minutes * 60))
            }
        }

        Divider()
        Toggle("Запускать при входе", isOn: Binding(
            get: { controller.loginItemEnabled },
            set: { controller.setLoginItemEnabled($0) }
        ))

        if controller.loginItemNeedsApproval {
            Button("Открыть настройки входа") {
                controller.openLoginItemsSettings()
            }
        }

        if let errorMessage = controller.errorMessage {
            Divider()
            Text(errorMessage)
        }

        Divider()
        Button("Выйти") {
            NSApp.terminate(nil)
        }
    }
}
