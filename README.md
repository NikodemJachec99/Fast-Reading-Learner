# Fast Reading Learner

[![CI](https://github.com/NikodemJachec99/Fast-Reading-Learner/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/NikodemJachec99/Fast-Reading-Learner/actions/workflows/ci.yml)

A Flutter app for learning and practising speed reading, built as a
Software Engineering team project.

## Requirements

- [Flutter](https://docs.flutter.dev/get-started/install) **3.47.7** (stable channel, Dart 3.13).
  The version is pinned in [`.fvmrc`](.fvmrc) and CI uses exactly that one, so
  please use the same version locally (`flutter --version`).
  The easiest way is [FVM](https://fvm.app) (see below).
- For Android builds: Android Studio with the Android SDK.
- For iOS builds: a Mac with Xcode.
- An editor with Flutter support: VS Code (recommended extensions are suggested
  automatically) or Android Studio.

## Getting started

```bash
git clone https://github.com/NikodemJachec99/Fast-Reading-Learner.git
cd Fast-Reading-Learner
flutter pub get
flutter run            # pick a device: emulator, phone or Chrome
```

### Using FVM (recommended)

[FVM](https://fvm.app/documentation/getting-started/installation) installs and
uses the Flutter version pinned in `.fvmrc`, so everyone on the team works with
the same SDK:

```bash
fvm install            # installs the version from .fvmrc
fvm flutter pub get    # prefix flutter commands with `fvm`
fvm flutter run
```

In VS Code, point the Dart extension at the FVM SDK by adding
`"dart.flutterSdkPath": ".fvm/versions/3.47.7"` to your **user** settings
(not the shared `.vscode/settings.json`, so it does not affect teammates
without FVM).

When upgrading Flutter, change the version in `.fvmrc` in a separate PR;
CI picks it up automatically.

## Everyday commands

| Task                    | Command                                  |
| ----------------------- | ---------------------------------------- |
| Run the app             | `flutter run`                            |
| Run all tests           | `flutter test`                           |
| Run tests with coverage | `flutter test --coverage`                |
| Check coverage minimum  | `./scripts/check_coverage.sh`            |
| Static analysis         | `flutter analyze`                        |
| Format code             | `dart format lib test`                   |

Run `dart format lib test && flutter analyze && flutter test` before every push.
CI additionally builds the app for web, Android and iOS on every pull request.

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
