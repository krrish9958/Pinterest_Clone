# Pinterest Clone Mobile App

A Flutter Pinterest clone focused on UI accuracy, clean architecture, and smooth performance.

## Tech Stack

- `flutter_riverpod` for state management
- `go_router` for navigation
- `dio` for networking
- `cached_network_image` for image caching
- `shimmer` for loading placeholders
- `flutter_staggered_grid_view` for masonry grid layout
- `clerk_flutter` for authentication

## Features

- Clerk-based auth gate
- Pinterest-style masonry home feed
- Search with pagination
- Pin detail view with Hero transition and action bar
- Pull-to-refresh and infinite scrolling
- Cached network images + shimmer loading
- Bottom tab navigation with preserved tab state (`IndexedStack`)

## Project Structure

The project follows a clean architecture-inspired structure:

- `presentation`: screens, UI state, Riverpod notifiers/providers
- `domain`: entities, repository contracts, use cases
- `data`: datasources, repository implementations, API models

## Environment Setup

Create a `.env` file in the project root:

```env
CLERK_PUBLISHABLE_KEY=your_clerk_publishable_key
PEXELS_API_KEY=your_pexels_api_key
```

You can also pass them with `--dart-define`:

```bash
flutter run --dart-define=CLERK_PUBLISHABLE_KEY=... --dart-define=PEXELS_API_KEY=...
```

## Run Locally

```bash
flutter pub get
flutter run
```

## QA Commands

```bash
flutter analyze
flutter test
```

## Build APK

```bash
flutter build apk --release
```

Output:

- `build/app/outputs/flutter-apk/app-release.apk`

## Notes

- Do not commit `.env` (already ignored by `.gitignore`).
- Pexels API key is loaded from env at runtime (not hardcoded in source).
