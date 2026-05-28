# Bluebird

Bluebird is an open-source, fully accessible file-sharing bridge between iOS and Windows.

## Objective
To provide a seamless, free, and accessible way to share files between Apple iOS devices and Windows PCs without requiring an Apple Developer account.

## Accessibility
Bluebird is designed for all users, including the blind. We adhere to WCAG 2.1 Level AA standards, ensuring full compatibility with VoiceOver (iOS) and screen readers like NVDA/Narrator (Windows).

## Project Structure
- `windows-app/`: Tauri-based desktop application (Rust).
- `bluebird_ios/`: Flutter-based iOS application (Dart).
- `shared-protocol/`: JSON schema for cross-platform communication.

## Getting Started

### Windows
1. Navigate to `windows-app/bluebird-windows`.
2. Run `npm install`.
3. Run `npm run tauri dev`.

### iOS
1. Navigate to `bluebird_ios`.
2. Configure your Flutter environment.
3. Use your preferred signing and sideloading tools (e.g., AltStore/SideStore) to build and deploy the `.ipa`.

## Contributing
We welcome contributions to make Bluebird better. Please ensure all new features are accessible and documented.

## License
MIT
