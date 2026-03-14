# Racecourse Tracks

Production Flutter app delivering racecourse analytics for the horse, harness, and greyhound racing industry. Empowers punters, trainers, and jockeys with data-driven insights — track geometry, wind patterns, distance to first turn — to optimize race strategy and betting decisions.

## Features

- **Racecourse Browser** — Filter and search courses by type (Gallops, Harness, Dogs), country, and state with multi-select
- **Track Analytics Dashboard** — Finish port data, wind direction, straight lengths, first turn distance, and width classification
- **Course Comparison** — Side-by-side comparison of up to 3 racecourses across all key metrics
- **Racing Scenarios** — Pre-built strategic scenarios with ideal conditions and matching example tracks
- **Authentication** — Email/password, Google Sign-In, and Apple Sign In with secure account management
- **Subscription Tiers** — Free and Pro access via RevenueCat with paywall integration
- **User Profiles** — Account settings, display name management, and admin features

## Architecture

```
lib/
├── config/              # App constants and configuration
├── data/
│   ├── services/        # Firebase, Auth, RevenueCat integrations
│   └── repositories/    # Data abstraction layer (15+ repositories)
├── domain/
│   └── models/          # User, Scenario, AppText domain models
├── ui/
│   ├── authentication/  # Sign-in / Sign-up flows
│   ├── dashboard/       # Main & Free-tier dashboards
│   ├── compare/         # Course comparison feature
│   ├── scenarios/       # Racing scenario views
│   ├── selection/       # Racecourse selection & filtering
│   ├── profile/         # User profile & settings
│   ├── subscription/    # Paywall & subscription UI
│   └── core/            # Theme, fonts, shared components
└── utils/               # Utility functions
```

**Pattern:** MVVM + Provider state management with Repository pattern for data abstraction.

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter (Dart 3.0.5+) |
| State Management | Provider 6.x |
| Backend | Firebase (Auth, Firestore, Cloud Functions) |
| Auth | Email, Google Sign-In, Apple Sign In |
| Monetization | RevenueCat + Google Mobile Ads |
| HTTP | Dio 5.x |
| Data | Cloud Firestore, SharedPreferences |
| UI | Flutter SVG, custom navigation, native splash |

## Getting Started

### Prerequisites
- Flutter SDK (stable channel)
- Firebase project with Firestore, Auth, and Cloud Functions enabled
- LM Studio or similar (if using AI features)

### Setup

```bash
git clone https://github.com/shaqir/Racecourse-Flutter.git
cd Racecourse-Flutter
flutter pub get
```

Configure Firebase:
1. Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
2. Update `firebase_options.dart` with your project config

```bash
flutter run
```

## Platform Support

| Platform | Min Version |
|----------|------------|
| iOS | 13.0+ |
| Android | API 21+ |

## Version

Current: **v1.8.16** (build 49) — 177+ commits of active development.

## Author

**Sakir Saiyed** — Senior Mobile Engineer

## License

MIT
