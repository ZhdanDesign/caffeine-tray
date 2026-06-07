import Combine
import Foundation

final class CaffeineController: ObservableObject {
    @Published private(set) var isActive = false
    @Published private(set) var remainingSeconds: TimeInterval = 0
    @Published private(set) var errorMessage: String?
    @Published private(set) var loginItemEnabled = false
    @Published private(set) var loginItemNeedsApproval = false

    private let service = CaffeinateService()
    private let loginItemService = LoginItemService()
    private var endDate: Date?
    private var timer: AnyCancellable?
    private var terminateObserver: NSObjectProtocol?

    init() {
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
            errorMessage = "Не удалось запустить caffeinate"
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
            errorMessage = enabled
                ? "Не удалось включить автозапуск"
                : "Не удалось отключить автозапуск"
        }
    }

    func openLoginItemsSettings() {
        loginItemService.openSystemSettings()
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
