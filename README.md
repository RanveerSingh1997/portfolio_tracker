# Portfolio Tracker

A Flutter starter app for **personal investment portfolio management**. The current MVP targets **Android and iOS**, fetches portfolio data through a **Dio-backed localhost mock API**, and now follows an **Injectable + GetIt + GoRouter + BLoC/Cubit** architecture with centralized localization and error handling.

## Current MVP

- Dashboard with portfolio summary metrics
- Cash management with local deposit and withdraw flows
- Holdings view with value, gain/loss, search, sector filtering, and sorting
- Transactions view with manual entry, search, type filters, and current-year filtering
- Allocation breakdown by sector
- Dashboard analytics, current-year tax summary, and JSON import/export tools
- Watchlist management and dividend tracking from the dashboard
- Feature-first structure backed by a localhost mock API plus local cache

## Project Structure

```text
lib/
  app/                    # App shell and router composition
    routes/
  core/
    di/                    # Injectable/GetIt registration
    errors/                # Shared app error mapping/reporting
    localization/          # l10n extensions around generated AppLocalizations
    network/               # Dio-backed client + localhost mock API
    theme/
  features/
    portfolio/
      domain/             # Entities and repository contracts
      data/               # Datasources, DTOs, repository implementations
      presentation/
        cubit/            # Portfolio state management
        pages/            # Screens
        widgets/          # Feature UI pieces
```

## Getting Started

```bash
flutter pub get
flutter gen-l10n
dart run build_runner build --delete-conflicting-outputs
dart analyze
flutter run
```

## Linting and Analyzer

The project uses Flutter's lint baseline plus project-specific analyzer settings in
`analysis_options.yaml`.

Use these commands during development:

```bash
dart analyze
flutter test
```

## Next Product Steps

1. Replace mock-cache persistence with a full local database.
2. Add richer tax workflows, live pricing, and performance history.
3. Add broker-friendly import formats plus backend-backed sync/auth flows.

## Project Guidelines

The working conventions for the app live in [`docs/project_guidelines.md`](docs/project_guidelines.md), including the project standards for **GoRouter-based navigation**, **Flutter gen_l10n localization**, **Dio-backed networking**, **Injectable-generated service registration**, and **BDD-style testing** alongside unit and widget tests.

## Architecture Walkthrough

For a code-first explanation with examples of **startup composition**, **routing**, **Injectable/GetIt DI**, **localhost mock API flow**, **typed `send(NetworkRequest)` transport**, **centralized error handling**, and **test harness structure**, read [`docs/architecture_guide.md`](docs/architecture_guide.md).
