# Cafe POS System

A Flutter-based point-of-sale application for cafe and restaurant operations.

## Overview

`cafe_pos_system` is a mobile POS system built with Flutter, Firebase Firestore, and Riverpod. It provides separate interfaces for waiters, kitchen staff, checkout, and menu administration.

## Key Features

- Home dashboard with role-specific entry points
- Table selection for waiter workflow
- Menu browsing and item selection per table
- Cart review and order submission to the kitchen
- Kitchen order lifecycle: new → in_kitchen → ready → paid
- Checkout view for processing ready orders
- Firebase Firestore backend for menu items and orders
- State management with Riverpod

## Screens and User Flows

1. **Home**
   - Main entry screen with buttons for Waiter, Kitchen, Checkout, and Manage Menu.

2. **Waiter / Tables**
   - Shows a grid of tables.
   - Tap a table to open the menu and add items to the cart.

3. **Menu / Table**
   - Loads menu items from Firestore.
   - Tap a menu item to add it to the cart for the selected table.

4. **Cart**
   - Shows selected items, quantities, and total price.
   - Send the order to the kitchen via Firestore.

5. **Kitchen**
   - Displays all active orders (not paid).
   - Update order status through the kitchen workflow.

6. **Checkout**
   - Displays orders marked `ready`.
   - Confirm payment and complete the order.

7. **Manage Menu**
   - Intended for menu administration and item availability.
   - Uses Firestore menu management via repository classes.

## Architecture

- `lib/main.dart` — app entrypoint and Firebase initialization
- `lib/ui/` — screen implementations for home, tables, menu, cart, kitchen, checkout, and admin menu
- `lib/providers/` — Riverpod providers for menu items, cart state, and orders
- `lib/data/models/` — domain models for `MenuItem` and `Order`
- `lib/data/repositories/` — Firestore repositories for menu and order persistence
- `lib/firebase_options.dart` — Firebase platform configuration file

## Dependencies

- `flutter` SDK
- `flutter_riverpod` for state management
- `firebase_core` for Firebase initialization
- `cloud_firestore` for Firestore database access
- `path_provider` and `path` for local file utilities
- `cupertino_icons` for icons

## Setup

1. Install Flutter and set up your development environment.
2. Open the project folder:

```bash
cd /Users/user/flutter/cafe_pos_system
```

3. Get dependencies:

```bash
flutter pub get
```

4. Run the app:

```bash
flutter run
```

## Firebase Configuration

The project initializes Firebase in `lib/main.dart` using `DefaultFirebaseOptions.currentPlatform`. Ensure the Firebase configuration files are present for your build platforms:

- Android: `android/app/google-services.json`
- iOS: `ios/Runner/GoogleService-Info.plist`

If you need to update Firebase settings, regenerate `firebase_options.dart` with `flutterfire configure`.

## Notes

- Orders are stored in Firestore collections: `menuItems` and `orders`.
- The kitchen workflow currently supports status changes from `new` → `in_kitchen` → `ready` → `paid`.
- The checkout page only shows orders with status `ready`.

## Improvements

Potential enhancements:

- Add authentication for staff roles
- Add menu item creation/edit/delete in the admin screen
- Add order history and sales reporting
- Add table reservation or split-bill support

## License

This repository is private and intended for internal development.

