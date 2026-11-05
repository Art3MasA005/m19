# Calorie Tracker

A Flutter app for recording food and tracking daily calorie intake against a 2,000 kcal goal.

## Features

- Home dashboard with today's date, total calories, daily goal, and remaining calories.
- Add Food page with required-field and positive-number validation.
- Daily Tracking page with a food list and delete controls.
- Shared in-memory food log: changes on either page update both pages immediately.
- The log resets when the app restarts. After a date change, it starts a new log when the app resumes or the user next adds or deletes food.

## Run locally

Install Flutter, then run:

```bash
flutter pub get
flutter run
```

To check the project:

```bash
flutter analyze
flutter test
```

The app uses only local memory. It does not need an account, database, or API key.
