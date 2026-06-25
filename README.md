# Dwelleo Mobile App

> Senior Flutter implementation plan for a bilingual Arabic/English AI-powered real-estate marketplace inspired by Dwelleo’s public web experience.

<p align="center">
  <img width="1367" height="270" alt="image" src="https://github.com/user-attachments/assets/cf2335c8-c707-4116-b1ba-727df169f9e4" alt="Dwelleo Mobile App" width="180"/>

</p>

<p align="center">
  <a href="#"><img alt="Flutter" src="https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter" /></a>
  <a href="#"><img alt="Dart" src="https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart" /></a>
  <a href="#"><img alt="Architecture" src="https://img.shields.io/badge/Architecture-Clean%20Architecture-purple" /></a>
  <a href="#"><img alt="Localization" src="https://img.shields.io/badge/Localization-AR%20%7C%20EN-green" /></a>
  <a href="#"><img alt="CI" src="https://img.shields.io/badge/CI-GitHub%20Actions-black?logo=githubactions" /></a>
</p>

## Table of Contents

- [Overview](#overview)
- [Product Vision](#product-vision)
- [Core Features](#core-features)
- [User Roles](#user-roles)
- [App Screens](#app-screens)
- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
- [API Layer](#api-layer)
- [Security and Sensitive Data](#security-and-sensitive-data)
- [Localization and RTL](#localization-and-rtl)
- [Firebase Services](#firebase-services)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Environment Variables](#environment-variables)
- [Code Generation](#code-generation)
- [App Icons and Splash Screen](#app-icons-and-splash-screen)
- [Branching Strategy](#branching-strategy)
- [GitHub Actions CI/CD](#github-actions-cicd)
- [Testing Strategy](#testing-strategy)
- [Roadmap](#roadmap)
- [Commit Rules](#commit-rules)
- [License](#license)

## Overview

Dwelleo Mobile App is a production-oriented Flutter application designed for the Saudi real-estate market. The app provides property discovery, project exploration, developer browsing, AI-powered search, market insights, and role-based account experiences from a single iOS and Android codebase.

The public Dwelleo experience includes buying, renting, off-plan discovery, commercial listings, AI Search, AI Sales Agent, subscriptions, verified properties, market intelligence, featured developers, and app-store distribution entry points. This mobile implementation translates that product direction into a scalable Flutter architecture with secure APIs, localization, CI/CD, and maintainable feature modules.

## Product Vision

The goal is to deliver a native-quality real-estate marketplace that helps users make confident decisions faster.

Dwelleo Mobile App should help:

- Buyers discover properties using smart filters, maps, AI search, and property insights.
- Renters find rental listings based on location, budget, property type, furnishing status, and travel time.
- Investors understand market data, price trends, estimated rental yield, and AI-driven recommendations.
- Sellers and brokers manage leads, subscriptions, and property listing flows.
- Developers showcase projects, available units, verified listings, and contact channels.
- Admin or internal teams monitor app quality, crashes, analytics, and release health.

## Core Features

### Property Discovery

- Buy, rent, off-plan, and commercial discovery flows.
- Property filters by listing type, property type, bedrooms, bathrooms, price, area, and advanced attributes.
- Listing cards with image gallery, price, city, beds, baths, area, furnishing state, owner/developer, and contact actions.
- Compare properties and save favorites.
- Show Map mode for location-based discovery.
- Travel-time search by destination, max minutes, transport mode, and peak traffic preference.

### Projects

- Browse real-estate projects across Saudi cities.
- Filter by city, developer, project type, and price.
- Project cards with starting price, verification state, listed date, bedrooms, bathrooms, area, developer, and call action.
- Project detail screen with overview, amenities, location, developer profile, available units, and FAQs.

### Developers, Brokers, and Agents

- Browse partner developers, brokers, and real-estate agents.
- Developer profile pages with logo, verification, projects, contact details, and properties.
- Featured developer carousel and category tabs.

### AI Search and AI Sales Agent

- Text-based AI property search.
- Voice search with microphone permission and audio upload.
- Suggested prompts such as apartments in Riyadh, villas for rent, properties with pool and gym, office space, and luxury penthouses.
- AI assistant response panel with matched properties and trending suggestions.
- Future AI Sales Agent flow for lead qualification, site-visit booking, buyer questions, and bilingual lead handling.

### Market Intelligence

- Market hub for data-driven real-estate decisions.
- City price statistics and charts.
- Market insight widgets for area trends, yearly changes, and investment signals.

### Authentication and Role-Based App

- Onboarding with language selection and role selection.
- Login and sign-up using email, phone, or backend-supported identity methods.
- Role-based navigation after authentication:
  - Buyer / renter interface
  - Seller / broker interface
  - Developer interface
  - Admin / internal interface when supported

## User Roles

| Role | Primary Experience |
|---|---|
| Guest | Browse public listings, projects, developers, AI search preview |
| Buyer | Search, save, compare, contact, request visits, receive alerts |
| Renter | Search rentals, travel-time filters, contact owners/brokers |
| Seller | List property, manage submissions, track leads |
| Broker | Manage multiple listings, leads, and contact flows |
| Developer | Showcase projects, units, availability, and leads |
| Admin | Internal dashboard and quality monitoring when enabled |

## App Screens

### Public Flow

- Splash screen
- Language selection
- Onboarding
- Role selection
- Login
- Sign up
- Forgot password / OTP verification

### Main Marketplace Flow

- Home dashboard
- Property search
- Property filters
- Property list
- Property map
- Property details
- Compare properties
- Saved properties
- Projects list
- Project details
- Developers list
- Developer profile
- Market insights
- AI Search
- AI Voice Search
- AI Sales Agent preview
- Contact support
- Profile and settings

### Seller / Developer Flow

- My listings
- Add property
- Property media upload
- Leads dashboard
- Subscriptions
- Project management
- Analytics summary

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter / Dart |
| Architecture | Clean Architecture + feature-first modules |
| State Management | Bloc/Cubit (only — no Riverpod/Provider/GetX) |
| Networking | Dio + interceptors (plain datasources — no Retrofit) |
| Models | Hand-written `fromJson`/`toJson` + `sealed class` state (no codegen) |
| Dependency Injection | get_it (manual registration — no injectable) |
| Local Storage | Drift / SQLite (SQLCipher), SharedPreferences |
| Secure Storage | flutter_secure_storage |
| Firebase | Core, Messaging, Analytics, Crashlytics, Performance, Remote Config, App Check |
| Maps | google_maps_flutter + geolocator |
| Voice Search | record + permission_handler + multipart upload |
| Localization | flutter_localizations + intl + ARB files |
| CI/CD | GitHub Actions |
| Release Automation | Fastlane or Codemagic when enabled |

## Architecture

This project follows Clean Architecture with clear boundaries between UI, domain logic, and data access.

```txt
Presentation Layer
  ├─ Screens
  ├─ Widgets
  ├─ Bloc/Cubit
  └─ View Models / UI State

Domain Layer
  ├─ Entities
  ├─ Repository Contracts
  └─ Use Cases

Data Layer
  ├─ API Providers
  ├─ DTO Models
  ├─ Repository Implementations
  ├─ Local Cache
  └─ Secure Storage

Core Layer
  ├─ Routing
  ├─ Theme
  ├─ Localization
  ├─ Error Handling
  ├─ Result / Failure Types
  ├─ Network Interceptors
  └─ Shared Utilities
```

### Architecture Goals

- Keep UI independent from API implementation details.
- Keep business logic testable and reusable.
- Support offline-first caching for listing and lookup data.
- Centralize API error handling, refresh tokens, and retry behavior.
- Isolate AI, auth, payment, analytics, and map logic into dedicated modules.
- Make it easy to add new user roles without rewriting the whole app.

## API Layer

All backend access is handled through feature-specific providers and repositories.

### API Client Responsibilities

- Attach locale header: `Accept-Language: en` or `ar`.
- Attach authorization token when available.
- Handle token refresh through an Auth Interceptor.
- Convert API exceptions to domain failures.
- Support pagination, filtering, sorting, and cancellation.
- Support multipart uploads for property images and AI voice search.
- Hide real endpoint details behind repositories.

### Expected API Modules

```txt
AuthApi
  POST /auth/register
  POST /auth/login
  POST /auth/logout
  GET  /profile

LookupApi
  GET /lookup

PropertyApi
  GET  /properties
  GET  /properties/{id_or_slug}
  POST /user/properties
  PUT  /user/properties/{id}
  DELETE /user/properties/{id}

ProjectApi
  GET /projects
  GET /projects/{id_or_slug}

DeveloperApi
  GET /developers
  GET /developers/locations
  GET /developers/{id_or_slug}

AiApi
  POST /user/ai/search
  POST /user/ai/voice-search
  GET  /user/ai/recommendations
  GET  /user/ai/property-score/{propertyId}

LeadApi
  POST /leads/ingest

SubscriptionApi
  GET  /user/subscriptions
  POST /user/subscriptions/checkout
```

> Endpoint names should be finalized against the official backend contract. Do not hardcode production secrets or private API keys in the Flutter app.

### Example Repository Contract

```dart
abstract class PropertyRepository {
  Future<PaginatedResult<PropertyEntity>> getProperties(PropertyFilter filter);
  Future<PropertyDetailsEntity> getPropertyDetails(String slug);
  Future<void> saveProperty(int propertyId);
  Future<void> compareProperty(int propertyId);
}
```

## Security and Sensitive Data

### Rules

- Never commit `.env`, API tokens, signing keys, Firebase private keys, or payment secrets.
- Use GitHub Secrets for CI/CD configuration.
- Use `flutter_secure_storage` for session tokens and refresh tokens.
- Use Firebase App Check where possible.
- Use HTTPS only.
- Strip sensitive data from logs.
- Disable verbose Dio logging in production.
- Use role-based access checks on backend and client.
- Validate file uploads before sending them.
- Do not store payment credentials on-device.

### Files That Must Stay Private

```txt
.env
.env.*
*.jks
*.keystore
key.properties
GoogleService-Info.plist
firebase_options_prod.dart
service-account.json
fastlane/Appfile
fastlane/Matchfile
```

Use `.gitignore` to prevent accidental commits.

## Localization and RTL

The app supports both English and Arabic.

### Requirements

- Use ARB files for translations.
- Generate localization classes with Flutter localization tooling.
- Wrap app content in `Directionality` based on selected locale.
- Use locale-aware date, number, and currency formatting.
- Mirror layout, icons, paddings, and navigation direction in Arabic.
- Test long Arabic strings in all cards and forms.

```txt
lib/l10n/
  app_en.arb
  app_ar.arb
```

## Firebase Services

Firebase should be initialized through a dedicated provider layer.

### Services

- Firebase Messaging for push notifications.
- Firebase Analytics for funnels and user behavior.
- Firebase Crashlytics for crash monitoring.
- Firebase Performance for API and startup monitoring.
- Firebase Remote Config for feature flags.
- Firebase App Check for abuse prevention.
- Firebase Storage only if the product flow requires client-managed uploads.

### Analytics Events

```txt
app_opened
language_selected
role_selected
login_completed
property_search_submitted
property_filter_applied
property_viewed
property_saved
property_compared
map_view_opened
project_viewed
developer_viewed
ai_search_started
ai_voice_query_submitted
lead_submitted
subscription_started
```

## Project Structure

Recommended feature-first structure:

```txt
lib/
├── main_dev.dart
├── main_staging.dart
├── main_prod.dart
├── app/
│   ├── app.dart
│   ├── router.dart
│   ├── theme/
│   └── localization/
├── core/
│   ├── constants/
│   ├── errors/
│   ├── network/
│   ├── security/
│   ├── storage/
│   ├── utils/
│   └── widgets/
├── features/
│   ├── auth/
│   ├── onboarding/
│   ├── home/
│   ├── property_search/
│   ├── property_details/
│   ├── saved_properties/
│   ├── compare/
│   ├── projects/
│   ├── developers/
│   ├── market_insights/
│   ├── ai_search/
│   ├── ai_voice_search/
│   ├── ai_sales_agent/
│   ├── listings_management/
│   ├── leads/
│   ├── subscriptions/
│   ├── payments/
│   ├── profile/
│   └── support/
└── l10n/
```

Each feature should follow:

```txt
feature_name/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── bloc/
    ├── pages/
    └── widgets/
```

## Getting Started

### Prerequisites

- Flutter stable channel
- Dart SDK
- Android Studio / Xcode
- Firebase CLI
- GitHub CLI optional
- A configured Firebase project
- Backend API base URL

### Install

```bash
git clone <repo-url>
cd dwelleo_mobile_app
flutter pub get
```

### Run Development Flavor

```bash
flutter run --flavor dev -t lib/main_dev.dart
```

### Run Staging Flavor

```bash
flutter run --flavor staging -t lib/main_staging.dart
```

### Run Production Flavor

```bash
flutter run --flavor prod -t lib/main_prod.dart
```

## Environment Variables

Create `.env.dev`, `.env.staging`, and `.env.prod` locally.

```env
APP_ENV=dev
API_BASE_URL=https://api.dwelleo.sa/api/v1
WEB_BASE_URL=https://dwelleo.sa
AI_BASE_URL=https://api.dwelleo.sa/api/v1
GOOGLE_MAPS_API_KEY=replace_with_local_key
SENTRY_DSN=
```

### CI/CD Secrets

Store these in GitHub Secrets:

```txt
API_BASE_URL_DEV
API_BASE_URL_STAGING
API_BASE_URL_PROD
GOOGLE_MAPS_API_KEY_ANDROID
GOOGLE_MAPS_API_KEY_IOS
FIREBASE_OPTIONS_DEV
FIREBASE_OPTIONS_STAGING
FIREBASE_OPTIONS_PROD
ANDROID_KEYSTORE_BASE64
ANDROID_KEYSTORE_PASSWORD
ANDROID_KEY_ALIAS
ANDROID_KEY_PASSWORD
APPLE_CERTIFICATE_BASE64
APPLE_CERTIFICATE_PASSWORD
APP_STORE_CONNECT_API_KEY_ID
APP_STORE_CONNECT_ISSUER_ID
APP_STORE_CONNECT_PRIVATE_KEY
```

## Localization Generation

Run after modifying any `.arb` file:

```bash
flutter gen-l10n
```

## App Icons and Splash Screen

Use:

```bash
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

### Android 12+ Splash Notes

Android 12+ uses a separate splash API. Provide a clean foreground icon and background color.

Recommended assets:

```txt
assets/images/launcher/dwelleo_icon.png
assets/images/launcher/dwelleo_icon_foreground.png
assets/images/launcher/dwelleo_icon_monochrome.png
assets/images/splash/dwelleo_splash.png
assets/images/splash/dwelleo_splash_dark.png
assets/images/splash/dwelleo_splash_android12.png
assets/images/splash/dwelleo_splash_android12_dark.png
```

## Branching Strategy

```txt
main
  Production-ready branch. Protected.

development
  Integration branch. Protected.

feature/<name>
  New features.

fix/<name>
  Bug fixes.

hotfix/<name>
  Urgent production fixes.

release/<version>
  Release stabilization.
```

### Protection Rules

Apply to `main` and `development`:

- Require pull request before merge.
- Require at least one approval.
- Require status checks to pass.
- Require branches to be up to date before merge.
- Block force pushes.
- Block direct pushes.
- Require signed commits when possible.
- Require conversation resolution.

## GitHub Actions CI/CD

Example workflow:

```yaml
name: Flutter CI

on:
  pull_request:
    branches: [development, main]
  push:
    branches: [development, main]

jobs:
  analyze-test-build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: "stable"
          channel: "stable"
          cache: true

      - name: Install dependencies
        run: flutter pub get

      - name: Verify formatting
        run: dart format --set-exit-if-changed .

      - name: Analyze
        run: flutter analyze

      - name: Run tests
        run: flutter test --coverage

      - name: Build Android debug
        run: flutter build apk --debug --flavor dev -t lib/main_dev.dart
```

### Future Deployment Jobs

- Firebase App Distribution for internal Android and iOS testing.
- TestFlight upload using Fastlane.
- Google Play internal testing upload using Fastlane.
- Automatic GitHub release notes from tags.

## Testing Strategy

### Unit Tests

- Use cases
- Repositories
- API mappers
- Validators
- Token refresh logic

### Widget Tests

- Onboarding
- Login and sign-up
- Property cards
- Filters
- Arabic RTL rendering
- Empty states and loading states

### Integration Tests

- Login flow
- Search flow
- Property details flow
- Save and compare flow
- AI voice search flow
- Role-based navigation

### Quality Gates

```bash
dart format --set-exit-if-changed .
flutter analyze
flutter test --coverage
flutter gen-l10n
flutter build apk --debug --flavor dev -t lib/main_dev.dart
```

## Roadmap

### Phase 1 – Foundation

- Project setup
- Flavors
- Environment configuration
- Clean Architecture structure
- Dependency injection
- Dio client
- Secure storage
- Firebase initialization
- Localization setup
- App icon and splash screen

### Phase 2 – Authentication and Onboarding

- Splash and onboarding
- Language selection
- Role selection
- Login
- Sign up
- OTP verification
- Role-based routing

### Phase 3 – Marketplace

- Home dashboard
- Property listing
- Property filters
- Property detail
- Saved properties
- Compare properties
- Map view
- Travel-time search

### Phase 4 – Projects and Developers

- Projects list
- Project detail
- Developers list
- Developer profile
- Contact actions

### Phase 5 – AI Features

- AI Search
- AI Voice Search
- AI Sales Agent UI
- Property score
- Price prediction
- Rental yield insights

### Phase 6 – Seller and Developer Tools

- Add property
- Upload media
- Manage listings
- Leads dashboard
- Subscriptions
- Payment flow

### Phase 7 – Production Release

- Crash monitoring
- Performance monitoring
- App Store metadata
- Play Store metadata
- TestFlight
- Google Play internal testing
- Security review
- Accessibility review

## Commit Rules

Use Conventional Commits:

```txt
feat: add property search filters
fix: handle token refresh failure
chore: configure flutter native splash
refactor: isolate auth repository
style: update home card spacing
test: add property mapper tests
docs: update README architecture section
```

## Senior Developer Notes

This project is designed to show ownership of the full mobile lifecycle:

- Architecture decisions
- API integration
- Secure authentication
- Firebase setup
- RTL/LTR localization
- CI/CD pipeline
- Release preparation
- Testing strategy
- App performance and crash monitoring
- Maintainable feature modules

## License

Proprietary. This project is intended as a professional Flutter mobile implementation for Dwelleo-style real-estate marketplace development.

