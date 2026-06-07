import SwiftUI

@main
struct CaffeineApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @StateObject private var controller = CaffeineController()

    var body: some Scene {
        MenuBarExtra {
            CaffeineMenuView(controller: controller)
        } label: {
            MenuBarLabelView(controller: controller)
        }
        .menuBarExtraStyle(.menu)
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
    }

    func applicationWillTerminate(_ notification: Notification) {
        NotificationCenter.default.post(name: .appWillTerminateCaffeine, object: nil)
    }
}
