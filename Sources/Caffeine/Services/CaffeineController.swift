import Combine
import Foundation

final class CaffeineController: ObservableObject {
    @Published private(set) var isActive = false
    @Published private(set) var remainingSeconds: TimeInterval = 0
    @Published private(set) var errorMessage: String?
    @Published private(set) var loginItemEnabled = false
    @Published private(set) var loginItemNeedsApproval = false
    @Published private(set) var languageMode: LanguageMode
    @Published private(set) var language: AppLanguage

    var strings: AppStrings {
        AppStrings(language: language)
    }

    private let service = CaffeinateService()
    private let loginItemService = LoginItemService()
    private let languageModeKey = "languageMode"
    private var endDate: Date?
    private var timer: AnyCancellable?
    private var terminateObserver: NSObjectProtocol?

    init() {
        let savedMode = UserDefaults.standard.string(forKey: languageModeKey)
            .flatMap(LanguageMode.init(rawValue:)) ?? .system
        languageMode = savedMode
        language = savedMode.resolvedLanguage

        terminateObserver = NotificationCenter.default.addObserver(
            forName: .appWillTerminateCaffeine,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.deactivate()
        }

        enableLoginItem()
    }

    deinit {
        if let terminateObserver {
            NotificationCenter.default.removeObserver(terminateObserver)
        }
        service.stop()
    }

    func activate(for seconds: TimeInterval) {
        guard seconds > 0 else { return }

        do {
            try service.start(for: seconds)
            endDate = Date().addingTimeInterval(seconds)
            errorMessage = nil
            startTimer()
            updateState()
        } catch {
            deactivate()
            errorMessage = strings.caffeinateStartError
        }
    }

    func deactivate() {
        service.stop()
        timer?.cancel()
        timer = nil
        endDate = nil
        isActive = false
        remainingSeconds = 0
    }

    func setLoginItemEnabled(_ enabled: Bool) {
        do {
            if enabled {
                try loginItemService.enable()
            } else {
                try loginItemService.disable()
            }
            refreshLoginItemState()
            errorMessage = nil
        } catch {
            refreshLoginItemState()
            errorMessage = enabled ? strings.loginItemEnableError : strings.loginItemDisableError
        }
    }

    func openLoginItemsSettings() {
        loginItemService.openSystemSettings()
    }

    func setLanguageMode(_ mode: LanguageMode) {
        languageMode = mode
        language = mode.resolvedLanguage
        UserDefaults.standard.set(mode.rawValue, forKey: languageModeKey)
        errorMessage = nil
    }

    private func startTimer() {
        timer?.cancel()
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateState()
            }
    }

    private func updateState() {
        guard service.isRunning, let endDate else {
            deactivate()
            return
        }

        let remaining = max(0, endDate.timeIntervalSinceNow)
        remainingSeconds = remaining
        isActive = remaining > 0

        if remaining <= 0 {
            deactivate()
        }
    }

    private func enableLoginItem() {
        setLoginItemEnabled(true)
    }

    private func refreshLoginItemState() {
        loginItemEnabled = loginItemService.isEnabled
        loginItemNeedsApproval = loginItemService.status == .requiresApproval
    }
}
