# lab5

A new Flutter project.

## Folder structure for this lab

- Original lab code is kept as backup in `lib/` (entry point: `lib/main.dart`).
- Rebuilt version using Repository + ViewModel + ConsumerWidget is in `lib/rebuild_mvvm/`.
- Rebuilt entry point: `lib/rebuild_mvvm/main_mvvm.dart`.
- ViewModel providers in rebuilt version use Riverpod code generation (`*.g.dart`).

Run rebuilt version:

```bash
flutter run -t lib/rebuild_mvvm/main_mvvm.dart

# generate/update .g.dart files
dart run build_runner build --delete-conflicting-outputs
```

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
