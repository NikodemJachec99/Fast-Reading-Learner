# Fast Reading Learner

A Flutter app for learning and practising speed reading, built as a
Software Engineering team project.

## Requirements

- [Flutter](https://docs.flutter.dev/get-started/install) **3.47.7** (stable channel, Dart 3.13).
  CI uses this exact version, so please use the same one locally
  (`flutter --version`).
- An editor with Flutter support: VS Code (recommended extensions are suggested
  automatically) or Android Studio.

## Getting started

```bash
git clone https://github.com/NikodemJachec99/Fast-Reading-Learner.git
cd Fast-Reading-Learner
flutter pub get
flutter run            # pick a device: emulator, phone or Chrome
```

## Everyday commands

| Task                    | Command                                  |
| ----------------------- | ---------------------------------------- |
| Run the app             | `flutter run`                            |
| Run all tests           | `flutter test`                           |
| Run tests with coverage | `flutter test --coverage`                |
| Check coverage minimum  | `./scripts/check_coverage.sh`            |
| Static analysis         | `flutter analyze`                        |
| Format code             | `dart format lib test`                   |

Run `dart format lib test && flutter analyze && flutter test` before every push;
this is exactly what CI checks.

## Project structure

```
lib/
  main.dart               # entry point
  src/
    app.dart              # MaterialApp, theme, root widget
    core/                 # app-wide logic, independent of the UI
      reading/            # reading speed, text chunking, ...
    features/             # one folder per feature / screen
      home/
test/                     # mirrors lib/: lib/src/x/y.dart -> test/src/x/y_test.dart
```

## Contributing

All changes go through pull requests with at least one approving review.
See [CONTRIBUTING.md](CONTRIBUTING.md) for the workflow.
