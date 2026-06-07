import SwiftUI

struct MenuBarLabelView: View {
    @ObservedObject var controller: CaffeineController

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: controller.isActive ? "cup.and.saucer.fill" : "cup.and.saucer")
            if controller.isActive {
                Text(DurationFormatter.short(controller.remainingSeconds))
            }
        }
        .foregroundStyle(controller.isActive ? .primary : .secondary)
    }
}
