import Foundation

struct CaffeineDuration: Identifiable, Equatable {
    let id: TimeInterval
    let title: String
    let seconds: TimeInterval

    init(title: String, minutes: Int) {
        self.title = title
        self.seconds = TimeInterval(minutes * 60)
        self.id = self.seconds
    }

    static let presets: [CaffeineDuration] = [
        CaffeineDuration(title: "30 минут", minutes: 30),
        CaffeineDuration(title: "1 час", minutes: 60),
        CaffeineDuration(title: "2 часа", minutes: 120),
        CaffeineDuration(title: "3 часа", minutes: 180)
    ]
}
