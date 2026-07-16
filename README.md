# Event Hopper — Events Discovery App

A responsive **Flutter** app for browsing events, viewing them on a map, and saving favorites.

## Features

- 🗺️ **Map view** — events plotted with Google Maps (`google_maps_flutter`), device location via `geolocator`
- 📅 **Event details** — full event pages with external links (`url_launcher`)
- ⭐ **Favorites** — saved locally with **Hive**, including a custom `LatLng` type adapter
- 👤 Profile screen, splash, and a shell with bottom navigation
- 🖥️ Desktop-aware (window sizing via `window_manager`)

## Stack

**Provider** + **get_it**, Hive persistence, feature screens under a main shell.

```
lib/
├── models/      # event model (+ Hive adapter)
├── Adapters/    # custom LatLng Hive adapter
├── providers/   # event state
└── screens/     # home, map, details, favorites, profile, splash
```

## Run it

```bash
flutter pub get
# add your Google Maps API key (Android/iOS config)
flutter run
```
