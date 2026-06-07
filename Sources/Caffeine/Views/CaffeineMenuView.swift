import SwiftUI

struct CaffeineMenuView: View {
    @ObservedObject var controller: CaffeineController

    var body: some View {
        let strings = controller.strings

        if controller.isActive {
            Text("\(strings.activePrefix): \(DurationFormatter.short(controller.remainingSeconds, language: controller.language))")
            Button(strings.deactivate) {
                controller.deactivate()
            }
            Divider()
        } else {
            Text(strings.inactive)
            Divider()
        }

        ForEach(CaffeineDuration.presets) { duration in
            Button(strings.durationTitle(minutes: duration.minutes)) {
                controller.activate(for: duration.seconds)
            }
        }

        Button(strings.customDuration) {
            if let minutes = CustomDurationPrompt.requestMinutes(strings: strings) {
                controller.activate(for: TimeInterval(minutes * 60))
            }
        }

        Divider()
        Toggle(strings.launchAtLogin, isOn: Binding(
            get: { controller.loginItemEnabled },
            set: { controller.setLoginItemEnabled($0) }
        ))

        if controller.loginItemNeedsApproval {
            Button(strings.openLoginItemsSettings) {
                controller.openLoginItemsSettings()
            }
        }

        Divider()
        Text(strings.languageSection)
        Button(languageModeTitle(.system, strings: strings)) {
            controller.setLanguageMode(.system)
        }
        Button(languageModeTitle(.russian, strings: strings)) {
            controller.setLanguageMode(.russian)
        }
        Button(languageModeTitle(.english, strings: strings)) {
            controller.setLanguageMode(.english)
        }

        if let errorMessage = controller.errorMessage {
            Divider()
            Text(errorMessage)
        }

        Divider()
        Button(strings.quit) {
            NSApp.terminate(nil)
        }
    }

    private func languageModeTitle(_ mode: LanguageMode, strings: AppStrings) -> String {
        let title: String
        switch mode {
        case .system:
            title = strings.languageSystem
        case .russian:
            title = strings.languageRussian
        case .english:
            title = strings.languageEnglish
        }

        return controller.languageMode == mode ? "✓ \(title)" : title
    }
}
