# Caffeine

Небольшое приложение для macOS menu bar, которое помогает держать Mac бодрствующим выбранное время.

[English README](README.en.md)

## Что это

`caffeinate` — это отдельная системная CLI-утилита macOS. Она уже есть в системе и умеет временно запрещать сон Mac.

`Caffeine` — это не замена `caffeinate`, а простой пользовательский интерфейс для нее: иконка в menu bar, быстрые таймеры, свое значение, статус и оставшееся время.

## Скриншоты

<p>
  <img src="docs/images/menu.png" alt="Меню Caffeine в строке меню macOS" width="280">
  <img src="docs/images/custom-duration.png" alt="Диалог своего значения таймера" width="280">
  <img src="docs/images/coffee-preview.jpg" alt="Иконка приложения Caffeine" width="220">
</p>

## Возможности

- Работает из строки меню macOS.
- Запускает и останавливает системную команду `caffeinate`.
- Быстрые таймеры: 30 минут, 1 час, 2 часа и 3 часа.
- Свое значение в минутах.
- Показывает активное или неактивное состояние через иконку.
- Показывает оставшееся время, пока режим активен.
- Может добавлять себя в автозапуск при входе в macOS.
- Использует иконку с чашкой кофе.

## Скачать готовое приложение

Готовую сборку можно скачать из раздела Releases:

[Download Caffeine.app](https://github.com/ZhdanDesign/caffeine-tray/releases/latest/download/Caffeine.zip)

После скачивания распакуйте архив и запустите `Caffeine.app`.

## Требования для сборки из исходников

- macOS 13 или новее.
- Xcode Command Line Tools.
- ImageMagick, чтобы сборочный скрипт мог создать `.icns` иконку приложения.

Установка ImageMagick через Homebrew:

```bash
brew install imagemagick
```

## Сборка и запуск

```bash
./script/build_and_run.sh
```

Скрипт собирает SwiftPM executable, создает `dist/Caffeine.app`, генерирует иконку из `Resources/coffe-icon.png` и запускает app bundle.

Проверить, что приложение запускается:

```bash
./script/build_and_run.sh --verify
```

## Использование

Откройте иконку в menu bar и выберите таймер:

- `30 минут`
- `1 час`
- `2 часа`
- `3 часа`
- `Свое значение...`

Чтобы остановить активный режим, нажмите `Деактивировать`.

## Лицензия

MIT
