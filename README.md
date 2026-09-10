# Birthday Planer

A Flutter app for keeping track of friends' birthdays, saving gift ideas, and getting reminded before the day.

## Features

- Store friends and their birthdays, optionally importing from your contacts
- Save gift ideas per person so you don't forget them
- Local notifications that remind you ahead of each birthday
- Works fully offline; data is stored on-device with Isar

## Tech

- Flutter / Dart
- Isar for local storage
- provider for state management
- flutter_local_notifications + timezone for reminders

## Running locally

Requires the Flutter SDK (Dart `^3.1.1`).

```bash
git clone https://github.com/robin-kli/birthday-planer.git
cd birthday-planer
flutter pub get
dart run build_runner build   # generates Isar code
flutter run

Targets Android and iOS. Contact import and notifications rely on native plugins and are not available on web or desktop.

Status

Personal project, version 0.0.1. Not published to any app store.
```
