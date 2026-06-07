import Foundation

enum LanguageMode: String, CaseIterable, Equatable {
    case system
    case russian
    case english

    var resolvedLanguage: AppLanguage {
        switch self {
        case .system:
            return AppLanguage.system
        case .russian:
            return .russian
        case .english:
            return .english
        }
    }
}
