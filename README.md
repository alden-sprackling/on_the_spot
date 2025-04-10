# On The Spot Game – Flutter Frontend

This Flutter application serves as the frontend for the On The Spot game. It handles user authentication, profile setup, game creation/joining, and real-time interactions. The app uses Provider for state management and connects to a secure backend API.

## Features
- **User Authentication:** Phone number login with OTP verification.
- **Profile Management:** Setup and update your player profile.
- **Game Sessions:** Create or join games with unique game codes.
- **Real-Time Communication:** Interact with other players in a game session.
- **Theming:** Custom app theme and colors.

## Setup
1. Clone the repository.
2. Navigate to the Flutter directory.
3. Run `flutter pub get` to install dependencies.
4. Update the `config.dart` file with your backend URL.
5. Run the app with `flutter run`.

## Deployment
- Use code signing and proper app store configurations.
- Secure API endpoints and use HTTPS.
- Consider using CI/CD for smooth deployments.
