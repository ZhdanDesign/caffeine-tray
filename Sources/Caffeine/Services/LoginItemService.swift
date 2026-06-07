import Foundation
import ServiceManagement

final class LoginItemService {
    private let service = SMAppService.mainApp

    var status: SMAppService.Status {
        service.status
    }

    var isEnabled: Bool {
        status == .enabled || status == .requiresApproval
    }

    func enable() throws {
        switch status {
        case .enabled, .requiresApproval:
            return
        case .notRegistered, .notFound:
            try service.register()
        @unknown default:
            try service.register()
        }
    }

    func disable() throws {
        switch status {
        case .notRegistered:
            return
        case .enabled, .requiresApproval, .notFound:
            try service.unregister()
        @unknown default:
            try service.unregister()
        }
    }

    func openSystemSettings() {
        SMAppService.openSystemSettingsLoginItems()
    }
}
