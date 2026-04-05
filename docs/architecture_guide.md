# Architecture Guide

This guide explains how the app is wired today, with examples from the current codebase.

## 1. Mental Model

The app follows this flow:

```text
UI -> Cubit -> Repository -> API Data Source -> AppNetworkClient -> Dio -> Localhost Mock API
```

Cross-cutting concerns are centralized:

- **Routing:** `lib/app/routes/`
- **Dependency injection:** `lib/core/di/`
- **Errors:** `lib/core/errors/`
- **Localization:** `lib/l10n/` and `lib/core/localization/`
- **Network transport:** `lib/core/network/`

## 2. App Startup

`PortfolioApp` is the composition root for the app UI:

```dart
return RepositoryProvider<PortfolioRepository>.value(
  value: resolvedRepository,
  child: BlocProvider(
    create: (context) => PortfolioCubit(
      repository: context.read<PortfolioRepository>(),
      errorHandler: resolvedErrorHandler,
    )..loadPortfolio(),
    child: MaterialApp.router(
      routerConfig: resolvedRouter,
      supportedLocales: AppLocalizations.supportedLocales,
    ),
  ),
);
```

What this means:

1. The repository is injected once.
2. The `PortfolioCubit` loads portfolio data on startup.
3. The app uses `MaterialApp.router` with centralized `GoRouter` config.
4. Localization delegates are registered at the app shell.

## 3. Dependency Injection

DI is managed by **GetIt + Injectable**.

### Entry point

`lib/core/di/service_locator.dart`

```dart
Future<void> setupServiceLocator({bool reset = false}) async {
  if (reset) {
    if (getIt.isRegistered<LocalMockApiServer>()) {
      await getIt<LocalMockApiServer>().close();
    }
    await getIt.reset();
  }

  await getIt.init();
}
```

### Module registration

`lib/core/di/register_module.dart`

```dart
@module
abstract class RegisterModule {
  @lazySingleton
  Dio dio(LocalMockApiServer server) => Dio(
    BaseOptions(baseUrl: server.baseUrl),
  );

  @preResolve
  Future<LocalMockApiServer> localMockApiServer() async {
    final server = LocalMockApiServer();
    await server.start();
    return server;
  }
}
```

Why this setup exists:

- `Injectable` keeps registrations consistent as the app grows.
- The mock API server starts before Dio is created.
- Tests can bypass app-wide DI by injecting fakes directly.

## 4. Routing

All route setup lives in `lib/app/routes/`.

### Router creation

```dart
GoRouter createAppRouter({
  String? initialLocation,
  AppErrorHandler? errorHandler,
}) {
  final resolvedErrorHandler = errorHandler ?? AppErrorHandler();

  return GoRouter(
    initialLocation: initialLocation ?? AppRoute.dashboard.location,
    routes: appPages,
    redirect: appRouteGuard,
    errorBuilder: (context, state) {
      return RouteErrorPage(
        error: resolvedErrorHandler.routeNotFound(state.uri.toString()),
      );
    },
  );
}
```

### Route usage

Use typed route metadata instead of inline strings:

```dart
context.go(AppRoute.holdings.location);
```

For parameterized navigation, use route helpers instead of building URLs by
hand:

```dart
context.goToHoldingDetails('AAPL');
```

Why this matters:

- Route definitions stay discoverable in one place.
- Deep links and route errors are handled centrally.
- Widgets do not own redirect or parsing logic.

## 5. Data Flow Example

The portfolio feature fetches data through a strict chain:

### Cubit

```dart
final snapshot = await _repository.fetchPortfolio();
emit(
  state.copyWith(
    status: PortfolioStatus.success,
    overview: snapshot.overview,
    holdings: snapshot.holdings,
    transactions: snapshot.transactions,
  ),
);
```

### Repository

```dart
@override
Future<PortfolioSnapshot> fetchPortfolio() async {
  final cachedPortfolio = await _cacheDataSource.loadPortfolio();
  if (cachedPortfolio != null) {
    return cachedPortfolio.toDomain();
  }

  final portfolio = await _apiDataSource.fetchPortfolio();
  await _cacheDataSource.savePortfolio(portfolio);
  return portfolio.toDomain();
}
```

### Data source

```dart
return _networkClient.send(
  NetworkRequest<PortfolioSnapshotDto, Never>(
    path: '/portfolio',
    type: NetworkRequestType.get,
    decoder: PortfolioSnapshotDto.fromResponse,
  ),
);
```

### Network client contract

```dart
abstract class AppNetworkClient {
  Future<TResponse> send<TResponse, TBody>(
    NetworkRequest<TResponse, TBody> request,
  );
}
```

### Why `send()` is important

`send()` now owns transport serialization:

- encodes request bodies before sending,
- calls Dio,
- decodes raw response payloads into typed objects before returning,
- maps transport and parsing failures into app-safe `AppError` values.

That keeps repository and data source code focused on feature intent instead of HTTP parsing.

### DTO serialization

Portfolio DTOs now use Flutter's recommended generated JSON serialization
approach with `json_annotation` + `json_serializable`.

That gives the project:

- less handwritten JSON boilerplate,
- generated `fromJson` / `toJson`,
- easier cache persistence,
- cleaner DTO growth as payloads expand.

Validation still stays explicit in the DTO layer so malformed payloads are
rejected with predictable parse errors.

### Network configuration

Transport settings now come from a dedicated `NetworkConfig` object instead of
being hardcoded inside the DI factory. That makes timeouts and startup behavior
easier to adjust per environment.

## 6. Offline Cache

The repository now keeps a lightweight local cache of the latest successful
portfolio snapshot.

Flow:

1. Load the cached snapshot first when one exists.
2. Save successful API responses back into cache.
3. Persist local user actions like manual transactions and cash updates into that same cache.
4. Fall back to the cached snapshot when the network path is unavailable.

This keeps the app usable offline and lets local portfolio edits survive app restarts.

## 7. Local Portfolio Actions

The app now supports local-first portfolio mutations without needing a real backend
yet.

Examples:

- add a buy/sell/dividend transaction from the transactions screen,
- deposit or withdraw cash from the dashboard,
- filter transaction history by search, type, and current-year activity,
- export the current portfolio snapshot as validated JSON and import it back into cache,
- derive dashboard analytics and tax summaries directly from the current snapshot,
- persist a local watchlist separately from the server-backed portfolio snapshot,
- derive dividend tracking metrics from the transaction stream without adding a new backend,
- update holdings lists immediately from Cubit state after the repository writes
  the new snapshot to cache.

This is a practical MVP pattern: user actions feel real, but the feature still
fits the current mock-API architecture.

## 8. Localhost Mock API

The app currently uses a local in-process HTTP server instead of reading files directly from `rootBundle`.

Example behavior:

```dart
if (request.method == 'GET' && request.uri.path == '/portfolio') {
  request.response.statusCode = HttpStatus.ok;
  request.response.write(jsonEncode(portfolioSnapshotPayload));
}
```

Why this is useful:

- Dio exercises a real HTTP path.
- The app can grow into more endpoints without changing feature code.
- The mock layer can inspect method and path like a real API.

## 9. Error Handling

Errors are managed centrally in `core/errors/`.

### In state management

```dart
} catch (error, stackTrace) {
  _errorHandler.report(error, stackTrace, reason: 'Portfolio load failed');
  emit(
    state.copyWith(
      status: PortfolioStatus.failure,
      error: _errorHandler.toAppError(
        error,
        fallbackType: AppErrorType.portfolioLoad,
      ),
    ),
  );
}
```

What this gives you:

- one place to map exceptions to app-safe errors,
- one place to report failures,
- consistent UI-facing messaging.

The app now distinguishes common failure types such as timeout, connection,
HTTP, parsing, and route errors so the UI does not have to reason about Dio or
raw exceptions.

## 10. Localization

Localization uses Flutter's official `gen_l10n` pipeline.

Source of truth:

- `lib/l10n/app_en.arb`
- `lib/l10n/app_hi.arb`

Usage stays ergonomic through extensions:

```dart
Text(context.l10n.appTitle)
Text(context.l10n.errorMessage(error))
Text(context.l10n.formatCurrency(holding.marketValue))
```

Use ARB files for strings and keep helper extensions small and formatting-focused.

## 11. Section-Level State

Portfolio state is no longer only "all or nothing".

- `overviewStatus`
- `holdingsStatus`
- `transactionsStatus`

That allows one part of the feature to refresh or fail without forcing every
screen into the same loading/error state.

## 12. Testing Strategy

The project uses three levels of testing:

### Unit / logic-focused

Use for Cubits, mappers, import/export validation, and domain business rules like
analytics or tax calculations.

### Widget tests

Use for screen rendering, navigation behavior, and the presence of important
dashboard/transactions controls.

The app test harness injects a fake repository:

```dart
await tester.pumpWidget(
  PortfolioApp(
    repository: repository,
    errorHandler: errorHandler,
    router: createAppRouter(
      initialLocation: initialLocation,
      errorHandler: errorHandler,
    ),
  ),
);
```

This avoids real HTTP in widget tests and keeps them deterministic.

### BDD widget tests

Use for product-readable scenarios, such as opening the portfolio dashboard and seeing key values.

## 13. How to Add a New Feature

Use this checklist:

1. Create the feature under `lib/features/<feature_name>/`.
2. Add entities and repository contract under `domain/`.
3. Add DTOs, data source, and repository implementation under `data/`.
4. Add Cubit and pages under `presentation/`.
5. Register dependencies with Injectable annotations.
6. Add routes in `lib/app/routes/`.
7. Add strings to ARB files.
8. Add unit tests, widget tests, and BDD coverage only for the important product flows.

## 14. Practical Boundaries

This project is intentionally practical:

- **Cubit first**
- **centralized routes**
- **centralized errors**
- **official localization**
- **Injectable-generated DI**
- **Dio-backed network layer**
- **localhost mock API for MVP**

Startup is also hardened so if DI or mock API bootstrapping fails, the app can
still show a basic fallback error shell instead of crashing silently.

If a new abstraction does not improve readability, safety, or growth, do not add it.
