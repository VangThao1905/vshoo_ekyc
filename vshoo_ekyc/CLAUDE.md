# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

`vshoo_ekyc` is a Flutter federated plugin for eKYC (electronic Know Your Customer). It is currently in early scaffolding — the intended architecture (Clean Architecture with functional programming) is signaled by the dev dependencies but not yet implemented.

## Common Commands

```bash
# Install dependencies
flutter pub get

# Code generation (freezed, json_serializable, injectable)
dart run build_runner build --delete-conflicting-outputs

# Run unit tests
flutter test

# Run integration tests (requires a device/emulator)
cd example && flutter test integration_test/

# Lint / static analysis
flutter analyze

# Build example app
cd example && flutter build apk   # Android
cd example && flutter build ios   # iOS

# Validate iOS podspec
pod lib lint ios/vshoo_ekyc.podspec
```

## Architecture

This is a **Flutter Federated Plugin** with the standard three-layer structure:

```
VshooEkyc (public API)
  └── VshooEkycPlatform (abstract platform interface)
        └── MethodChannelVshooEkyc (concrete Dart impl via MethodChannel)
              ├── Android: VshooEkycPlugin.kt
              └── iOS: VshooEkycPlugin.swift
```

- `lib/vshoo_ekyc.dart` — public-facing `VshooEkyc` class; delegates all calls to the platform interface
- `lib/vshoo_ekyc_platform_interface.dart` — abstract `VshooEkycPlatform` using `PlatformInterface` with token verification; defines the contract all platform implementations must fulfill
- `lib/vshoo_ekyc_method_channel.dart` — `MethodChannelVshooEkyc` communicates over `MethodChannel('vshoo_ekyc')`
- `android/.../VshooEkycPlugin.kt` — registers and handles the method channel on Android
- `ios/Classes/VshooEkycPlugin.swift` — same on iOS

## Intended Architecture (Not Yet Implemented)

The dev dependencies signal a planned **Clean Architecture** with:
- **freezed** + **json_serializable** — immutable data models with JSON serialization (generates `.freezed.dart` / `.g.dart` files)
- **dartz** — functional error handling via `Either<Failure, Success>` pattern
- **injectable** + **injectable_generator** — dependency injection (note: `injectable` runtime package is missing from regular dependencies and must be added before DI codegen works)

No `.g.dart` or `.freezed.dart` files exist yet — `build_runner` has not been run.

## Platform Configuration

| Platform | Min version | Language |
|----------|-------------|----------|
| Android  | API 21      | Kotlin 1.8.22, compileSdk 34 |
| iOS      | 12.0+       | Swift 5.0 |

The iOS privacy manifest (`ios/Resources/PrivacyInfo.xcprivacy`) exists but is not yet wired into the podspec.