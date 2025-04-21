
# Flutter Nexus Mobile Hub

A comprehensive Flutter mobile application demonstrating various Android mobile development concepts, built for MAM66-Mobile and Application Development Lab Assessment II.

## Features

The application implements all the required elements for the assessment:

1. **Appropriate Layout** - Material Design with custom UI components, responsive design, and proper navigation.

2. **Database Connectivity** - SQLite database implementation using the `sqflite` package for local storage of tasks.

3. **Notification Settings** - Local notifications management using `flutter_local_notifications` with options to schedule and customize notifications.

4. **Multithreading Concept** - Isolate implementation for performing heavy computations without blocking the UI thread.

5. **GPS Location Information** - Location tracking using `geolocator` and `geocoding` packages to get coordinates and address information.

6. **RSS Feed for Website** - RSS feed reader with the ability to fetch and display content from any RSS feed URL.

7. **Sending and Receiving Email** - Email functionality using `flutter_email_sender` to compose and send emails.

8. **Innovation in the Project** - Voice command system using speech recognition (`speech_to_text`) and text-to-speech (`flutter_tts`) for hands-free app control.

## Project Structure

- `lib/main.dart`: Entry point of the application
- `lib/models/`: Data models for the application
- `lib/providers/`: State management using Provider
- `lib/screens/`: All UI screens of the application
- `lib/utils/`: Utility services for various functionalities
- `assets/`: Application assets (images, etc.)

## Screens

1. **Home Screen**: Navigation hub with cards for each feature
2. **Database Screen**: Task management with SQLite
3. **Notification Screen**: Notification settings and scheduling
4. **Multithreading Screen**: Demo of UI vs background thread processing
5. **Location Screen**: GPS location tracking and display
6. **RSS Screen**: RSS feed reader
7. **Email Screen**: Email composition and sending
8. **Voice Command Screen**: Innovative voice control feature

## Technical Implementation

- **State Management**: Provider pattern for app-wide state
- **Database**: SQLite with sqflite package
- **Navigation**: Material route-based navigation
- **Concurrency**: Isolates for background processing
- **Location Services**: Geolocator and Geocoding
- **Networking**: HTTP requests for RSS feeds
- **Speech Recognition**: Speech-to-text and text-to-speech

## Requirements

- Flutter SDK: >=2.19.0 <3.0.0
- Android SDK: 21+
- iOS 11+

## Dependencies

- provider: ^6.0.5
- sqflite: ^2.2.8+4
- flutter_local_notifications: ^14.1.1
- geolocator: ^9.0.2
- geocoding: ^2.1.0
- http: ^0.13.6
- xml: ^6.3.0
- flutter_email_sender: ^6.0.1
- speech_to_text: ^6.1.1
- flutter_tts: ^3.6.3
- and more...

## Installation and Running

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Connect a device or emulator
4. Run `flutter run` to start the application
