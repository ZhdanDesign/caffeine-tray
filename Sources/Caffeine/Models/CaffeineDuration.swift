import Foundation

struct CaffeineDuration: Identifiable, Equatable {
    let id: TimeInterval
    let minutes: Int
    let seconds: TimeInterval

    init(minutes: Int) {
        self.minutes = minutes
        self.seconds = TimeInterval(minutes * 60)
        self.id = self.seconds
    }

    static let presets: [CaffeineDuration] = [
        CaffeineDuration(minutes: 30),
        CaffeineDuration(minutes: 60),
        CaffeineDuration(minutes: 120),
        CaffeineDuration(minutes: 180)
    ]
}
