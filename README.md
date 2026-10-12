# MealDB Application

MealDB Application is a Flutter mobile app that helps users explore meals from TheMealDB API. It provides a clean recipe-discovery experience with browsing, filtering, search, favorites, and user account features.

## Project overview

This project is designed as a complete food/recipe app where users can:

- Browse meals by category, area, and ingredient
- Search for meals by name
- Open detailed meal pages with instructions, ingredients, and images
- Save favorite meals locally for quick access
- Create or log in to a user account and manage a profile
- Adjust app settings in a simple mobile-friendly interface

The app combines a remote API with local persistence, making it a good example of a Flutter app that uses both online data and offline data storage.

## Main features

- Food discovery from TheMealDB API
- Category-based browsing
- Area-based filtering
- Ingredient-based filtering
- Meal search and detail view
- Local favorites using SQLite
- Authentication flow with local user storage
- User profile management
- Responsive Material Design UI
- State management with Flutter BLoC

## Tech stack

- Flutter / Dart
- BLoC for state management
- Dio for API requests
- SQLite for local database storage
- SharedPreferences for lightweight app preferences
- Image picker support for profile images
- Material Design components

## Project structure

```text
lib/
├── main.dart
├── root.dart
├── splash.dart
├── core/
│   ├── Database/
│   ├── constants/
│   ├── features/
│   │   ├── auth/
│   │   ├── favorites__Local/
│   │   ├── Filters/
│   │   ├── home/
│   │   └── settings/
│   ├── network/
│   ├── shared/
│   └── utils/
``` 

## App workflow

1. The app launches with a splash screen.
2. Users log in or sign up through the authentication flow.
3. The home screen displays meal categories, areas, and ingredients.
4. Users can search for meals or filter by selected categories/areas/ingredients.
5. Meal details show instructions and ingredients.
6. Favorite meals are saved locally so users can revisit them anytime.
7. The profile and settings screens allow personalization and account management.

## Getting started

### Prerequisites

- Flutter SDK installed
- Android Studio or VS Code with Flutter support
- A device or emulator

### Install dependencies

```bash
flutter pub get
```

### Run the app

```bash
flutter run
```

### Build for release

```bash
flutter build apk
```

## Notes

This project uses the TheMealDB public API and a local SQLite database (`mealdb.db`) for app-specific data such as favorites and user information.

## License

This project is for educational/demo use unless otherwise stated by the project owner.
