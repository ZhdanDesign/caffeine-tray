import Foundation

enum DurationFormatter {
    static func short(_ seconds: TimeInterval) -> String {
        let totalMinutes = max(0, Int(ceil(seconds / 60)))
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60

        if hours > 0, minutes > 0 {
            return "\(hours)ч \(minutes)м"
        }

        if hours > 0 {
            return "\(hours)ч"
        }

        return "\(max(1, minutes))м"
    }
}
