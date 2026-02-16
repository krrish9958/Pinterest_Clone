<img width="1918" height="1012" alt="pintrest3" src="https://github.com/user-attachments/assets/b70caed0-e27b-4a7e-990e-457a653562ff" />
<img width="1918" height="992" alt="pintrest2" src="https://github.com/user-attachments/assets/7ac8887c-56ac-44a8-b1f7-461aa5695e5b" />
<img width="1918" height="1022" alt="pinterest1" src="https://github.com/user-attachments/assets/a650f8ba-5804-4acd-a036-ca56838d6460" />
<img width="1901" height="993" alt="image" src="https://github.com/user-attachments/assets/14e8193d-9c96-484c-befe-e2c3d45c140b" />
<img width="1919" height="990" alt="image" src="https://github.com/user-attachments/assets/91ad6e60-867e-4cda-87c0-34626cff66c0" />
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
