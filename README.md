# Star Wars Cinema & Movies App

A cross-platform Flutter application that consumes the [Star Wars API (SWAPI)](https://swapi.dev/) to browse films, view detailed universe data, locate nearby cinemas, and set movie showtime reminders. 

The dark UI theme is cloned from Disney+.

---

## Features

- **Film Catalog & Details**:
  - Film list displaying title, episode roman numerals, release dates, and posters.
  - Detail screen with opening crawl summary, director, and producer.
  - Bottom sheet lookups for related characters/actors, planets, starships, vehicles, and species.
- **Cinema Locator & Navigation**:
  - Google Maps integration displaying mock cinema locations (20+ locations for Cinema XXI and CGV).
  - Fetches current device GPS location with fallback coordinates.
  - Displays driving route polylines, distance (km), and estimated time of arrival (ETA).
  - Option to open directions in external map apps (Google Maps).
- **Movie Reminders**:
  - Schedules local push notifications using `flutter_local_notifications` with timezone support.
  - Customizable alert offsets (at showtime, 15m, 30m, or 1h before) with custom notes.
  - Persisted locally with `shared_preferences`.

---

## Architecture & State Management

The application is built using **Clean Architecture** principles to separate concerns into distinct, testable layers, combined with **GetX** for reactive state management, route management, and dependency injection.

```
┌────────────────────────────────────────────────────────────────────────┐
│                          Presentation Layer                            │
│  • Views (GetView)                                                     │
│  • Controllers (GetxController with reactive state)                   │
│  • Bindings (Route-level dependency injection)                         │
│  • Widgets & UI Components                                             │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │ depends on
┌───────────────────────────────────▼────────────────────────────────────┐
│                             Domain Layer                               │
│  • Entities (Core business data models)                                │
│  • Use Cases (Single-responsibility business operations)               │
│  • Repository Interfaces (Abstract contracts)                          │
└───────────────────────────────────▲────────────────────────────────────┘
                                    │ implemented by
┌───────────────────────────────────┴────────────────────────────────────┐
│                              Data Layer                                │
│  • Models (Data transfer objects & JSON serialization)                 │
│  • Mappers (Conversion between Models and Domain Entities)             │
│  • Data Sources (Remote APIs: SWAPI & OSRM; Local: Mock Cinema JSON)  │
│  • Repository Implementations (Implements domain interfaces)          │
└────────────────────────────────────────────────────────────────────────┘
```

### Layer Breakdown

1. **Domain Layer (Core Business Logic)**
   - **Entities**: Pure Dart objects representing domain concepts (e.g., `FilmEntity`, `CinemaEntity`, `MovieReminder`). They have no dependencies on Flutter or data serialization libraries.
   - **Repository Interfaces**: Abstract contracts (e.g., `FilmRepository`, `CinemaRepository`) that define what data operations are required without dictating where or how data is fetched.
   - **Use Cases**: Encapsulate single business tasks (e.g., `GetFilmsUseCase`, `GetCinemaRouteUseCase`, `GetFilmDetailUseCase`). Controllers call use cases directly, keeping business workflows decoupled from the UI.

2. **Data Layer (Data Retrieval & Persistence)**
   - **Data Sources**: Handle raw I/O operations.
     - `FilmDataSourceImpl`: Communicates with SWAPI via Dio.
     - `CinemaRouteDataSourceImpl`: Queries OSRM routing for route coordinates and travel duration, with a straight-line Haversine distance fallback.
     - `CinemaLocalDataSourceImpl`: Loads bundled mock cinema coordinate data from assets.
   - **Models**: DTOs containing `fromJson` / `toJson` deserialization logic.
   - **Mappers**: Explicit extension mappers (e.g., `FilmMapper`, `CinemaMapper`) that transform incoming data models into immutable domain entities before handing them to repositories.
   - **Repository Implementations**: Implement the domain repository contracts, orchestrating data sources and applying mapping logic.

3. **Presentation Layer (UI & State)**
   - **Views**: Stateless screens extending `GetView<T>` that bind to a specific controller. Views only describe UI layouts and dispatch user actions to the controller.
   - **Widgets**: Reusable, modular UI components such as entity detail bottom sheets, cinema route cards, and reminder dialogs.

---

### State Management & Reactive Flow (GetX)

- **Reactive State (`Rx` & `Obx`)**:
  - Controller state variables are declared as reactive observables (e.g., `.obs`, `Rxn<FilmEntity>()`, `RxList`).
  - Views observe these observables using fine-grained `Obx()` blocks. Only the widgets wrapped in `Obx()` rebuild when their specific observable value changes, preventing unnecessary screen-wide rebuilds.

- **Dependency Injection via Route Bindings**:
  - Each route has a dedicated binding (e.g., `HomeBinding`, `FilmDetailBinding`, `CinemaBinding`, `ReminderBinding`).
  - Dependencies (Data Sources, Repositories, Use Cases, Controllers) are registered lazily using `Get.lazyPut()`. Instances are created only when the screen is navigated to and automatically disposed of when the route is removed from memory.

- **Event-Driven Reactive Sync**:
  - Cross-controller and cross-module synchronization is handled using reactive workers (such as `ever()`).
  - For example, when viewing a movie's details, an `ever()` listener watches the active `FilmEntity`. If reminders are scheduled, edited, or deleted in `ReminderController`, the movie detail view automatically reflects the updated reminder status without requiring tight coupling or direct widget callbacks between the two modules.

- **Separation of Concerns & Unit Testability**:
  - Controllers never communicate directly with data sources or Dio clients.
  - Because dependencies are injected via interfaces, every layer can be isolated and unit-tested with fakes/mocks (e.g., testing `ReminderController` with an in-memory `SharedPreferences` and fake notification service).

---

## Tech Stack

- **Flutter 3** (Dart 3)
- **State Management & Routing**: `get`
- **Network**: `dio`, `pretty_dio_logger`
- **Maps & Location**: `google_maps_flutter`, `geolocator`, `flutter_polyline_points`, OSRM routing
- **Notifications**: `flutter_local_notifications`, `timezone`
- **Storage**: `shared_preferences`
- **Utility**: `url_launcher`

---

## Project Structure

```
lib/
├── app/
│   ├── infrastructure/       # Theme, routes
│   ├── services/             # NotificationService
│   └── utils/                # Config, constants, helpers
├── data/
│   ├── datasource/           # Remote (SWAPI, OSRM) & local mock data
│   ├── mapper/               # Model to Entity mappers
│   ├── model/                # Raw API & JSON models
│   ├── network/              # Dio client setup
│   └── repository/           # Repository implementations
├── domain/
│   ├── entities/             # Core business models
│   ├── repositories/         # Abstract repository interfaces
│   └── usecase/              # Use case classes
├── presentation/
│   ├── cinema/               # Cinema map, route sheet, controller
│   ├── film_detail/          # Film info, entity sheets, controller
│   ├── home/                 # Film list & controller
│   └── reminder/             # Reminder sheet, model, controller
└── main.dart
```

---

## Getting Started

### 1. Prerequisites
- Flutter SDK 3.x
- Google Maps API key (with Maps SDK for Android & iOS enabled)

### 2. Setup Google Maps API Key

- **Android**: Add your key in `android/local.properties`:
  ```properties
  MAPS_API_KEY=YOUR_GOOGLE_MAPS_API_KEY
  ```
- **iOS**: Ensure your key is set in `ios/Runner/Info.plist`:
  ```xml
  <key>GoogleMapsApiKey</key>
  <string>YOUR_GOOGLE_MAPS_API_KEY</string>
  ```

### 3. Run

```bash
flutter pub get
flutter run
```

### 4. Tests

Run the unit and widget test suite:

```bash
flutter test
```
