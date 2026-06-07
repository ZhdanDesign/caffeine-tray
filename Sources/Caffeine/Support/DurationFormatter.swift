import Foundation

enum DurationFormatter {
    static func short(_ seconds: TimeInterval, language: AppLanguage) -> String {
        let totalMinutes = max(0, Int(ceil(seconds / 60)))
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        let hourSuffix = language == .russian ? "ч" : "h"
        let minuteSuffix = language == .russian ? "м" : "m"

        if hours > 0, minutes > 0 {
            return "\(hours)\(hourSuffix) \(minutes)\(minuteSuffix)"
        }

        if hours > 0 {
            return "\(hours)\(hourSuffix)"
        }

        return "\(max(1, minutes))\(minuteSuffix)"
    }
}
