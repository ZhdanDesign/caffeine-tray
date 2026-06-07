import Foundation

enum AppLanguage: String, CaseIterable, Equatable {
    case english
    case russian

    static var system: AppLanguage {
        let preferred = Locale.preferredLanguages.first ?? Locale.current.identifier
        return preferred.lowercased().hasPrefix("ru") ? .russian : .english
    }
}
