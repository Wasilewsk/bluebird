# Bluebird

Bluebird is an open-source, fully accessible file-sharing bridge between iOS and Windows.

## Objective
To provide a seamless, free, and accessible way to share files between Apple iOS devices and Windows PCs.

## Accessibility
Bluebird is designed for all users, including the blind, adhering to WCAG 2.1 Level AA standards.

## Project Structure
- `windows-app/`: Tauri-based desktop application (Rust).
- `bluebird_ios/`: Flutter-based iOS application (Dart/PWA).
- `shared-protocol/`: JSON schema for cross-platform communication.

## How to Run

### 1. Windows Application
1. Open terminal in `windows-app/bluebird-windows`.
2. Run `npm install`.
3. Run `npm run tauri dev`.

### 2. iOS Application (PWA)
1. Open terminal in `bluebird_ios`.
2. Run `flutter build web`.
3. Serve the `build/web` folder using a local web server (e.g., `python -m http.server 8000`).
4. On your iPhone, open Safari, navigate to your PC's local IP address (e.g., `http://192.168.1.X:8000`), and select "Add to Home Screen".

## Contributing
We welcome contributions to make Bluebird better. Ensure all new features are accessible and documented.

## License
MIT
