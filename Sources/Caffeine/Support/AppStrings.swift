import Foundation

struct AppStrings {
    let language: AppLanguage

    var activePrefix: String {
        switch language {
        case .english: "Active"
        case .russian: "Активен"
        }
    }

    var inactive: String {
        switch language {
        case .english: "Inactive"
        case .russian: "Не активен"
        }
    }

    var deactivate: String {
        switch language {
        case .english: "Deactivate"
        case .russian: "Деактивировать"
        }
    }

    var customDuration: String {
        switch language {
        case .english: "Custom value..."
        case .russian: "Свое значение..."
        }
    }

    var launchAtLogin: String {
        switch language {
        case .english: "Launch at login"
        case .russian: "Запускать при входе"
        }
    }

    var openLoginItemsSettings: String {
        switch language {
        case .english: "Open Login Items Settings"
        case .russian: "Открыть настройки входа"
        }
    }

    var languageSection: String {
        switch language {
        case .english: "Language"
        case .russian: "Язык"
        }
    }

    var languageSystem: String {
        switch language {
        case .english: "System"
        case .russian: "Системный"
        }
    }

    var languageRussian: String {
        switch language {
        case .english: "Russian"
        case .russian: "Русский"
        }
    }

    var languageEnglish: String {
        switch language {
        case .english: "English"
        case .russian: "Английский"
        }
    }

    var quit: String {
        switch language {
        case .english: "Quit"
        case .russian: "Выйти"
        }
    }

    var caffeinateStartError: String {
        switch language {
        case .english: "Could not start caffeinate"
        case .russian: "Не удалось запустить caffeinate"
        }
    }

    var loginItemEnableError: String {
        switch language {
        case .english: "Could not enable launch at login"
        case .russian: "Не удалось включить автозапуск"
        }
    }

    var loginItemDisableError: String {
        switch language {
        case .english: "Could not disable launch at login"
        case .russian: "Не удалось отключить автозапуск"
        }
    }

    var customDurationTitle: String {
        switch language {
        case .english: "Custom value"
        case .russian: "Свое значение"
        }
    }

    var customDurationMessage: String {
        switch language {
        case .english: "Enter duration in minutes."
        case .russian: "Введите длительность в минутах."
        }
    }

    var customDurationPlaceholder: String {
        switch language {
        case .english: "For example, 45"
        case .russian: "Например, 45"
        }
    }

    var start: String {
        switch language {
        case .english: "Start"
        case .russian: "Запустить"
        }
    }

    var cancel: String {
        switch language {
        case .english: "Cancel"
        case .russian: "Отмена"
        }
    }

    func durationTitle(minutes: Int) -> String {
        switch language {
        case .english:
            switch minutes {
            case 30:
                return "30 minutes"
            case 60:
                return "1 hour"
            default:
                let hours = minutes / 60
                return "\(hours) hours"
            }
        case .russian:
            switch minutes {
            case 30:
                return "30 минут"
            case 60:
                return "1 час"
            case 120:
                return "2 часа"
            case 180:
                return "3 часа"
            default:
                return "\(minutes) минут"
            }
        }
    }
}
