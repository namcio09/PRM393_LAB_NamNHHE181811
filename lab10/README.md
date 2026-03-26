# Lab 10 – Authentication, Session Management & Notifications

This Flutter app integrates every requirement from Lab 10: REST authentication, persistent sessions, Firebase Google Sign-In, and local notifications after successful logins.

## Highlights
- **Real API Login** – Uses the DummyJSON Auth API with proper validation and error handling.
- **Session Persistence** – Stores the authenticated user (token + profile) with `shared_preferences` and restores it on launch.
- **Auto-login & Logout** – Splash screen checks for previous sessions; logout clears storage and Firebase state.
- **Firebase Google Sign-In** – Optional Google login flow powered by `firebase_auth` and `google_sign_in` (button auto-disables until configured).
- **Local Notifications (LO7)** – `flutter_local_notifications` shows a notification whenever a login succeeds; replay button available on the home screen.

## Project Structure
- `lib/controllers/auth_controller.dart` – Central state machine for auth, notifications, and routing.
- `lib/repositories/auth_repository.dart` – Orchestrates REST login, Firebase auth, and storage.
- `lib/services/` – Contains REST API client, session storage, Firebase helper, and local notification wrapper.
- `lib/screens/` – Splash, Login, and Home experiences with purposeful visuals and responsive layouts.

## Running the App
1. Ensure Flutter (3.19+), Android Studio, and an emulator/device are ready. Enable Windows developer mode for plugin symlinks (`start ms-settings:developers`).
2. Install packages: `flutter pub get`.
3. Launch: `flutter run` (device/emulator must be logged in to the internet for DummyJSON and Firebase).

### DummyJSON Test Account
```
Username: kminchelle
Password: 0lelplR
```
Use any other DummyJSON credential as needed.

## Firebase & Google Sign-In Setup
Google Sign-In stays disabled until Firebase is configured. Steps:
1. Create a Firebase project and add Android app id `com.example.lab10` (change package name in `android/app/build.gradle.kts` if you prefer another id).
2. Download `google-services.json` into `android/app/`.
3. For iOS/macOS, download `GoogleService-Info.plist` into `ios/Runner/` and run `pod install` from `ios/`.
4. Rebuild the app. The Google button will become active once initialization succeeds.

## Local Notifications
- Android 13+ prompts for notification permission on first launch.
- Use the “Replay Login Notification” button on the home screen if you want to test the notification again without logging out/in.

## Notes for Lab Submission
- This repository already models the final integrated project (`Lab10_Full`).
- Each feature can be extracted into its own mini project if needed (Mock login, REST login, Auto Login, Firebase Sign-In, Notification).
- Update `README.md` with any additional instructions or alternative accounts you provide for grading.
