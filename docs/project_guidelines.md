# Project Guidelines

## 1. Product Scope

- Build a **personal investment tracker**, not a broker, advisor console, or trading platform.
- Stay **offline-first** for the MVP: local JSON-backed API mocks first, then local persistence, then optional remote sync.
- Target **Android and iOS** first.
- Optimize for **maintainability, readability, and safe iteration** over premature abstraction.

## 2. Architecture Principles

- Use a **feature-first** structure.
- Maintain strict flow: **UI -> State -> Domain -> Data**.
- Use **Cubit by default**; introduce full **BLoC** only when event sequencing, branching workflows, or side-effect orchestration becomes non-trivial.
- Keep repositories behind interfaces so **mock**, **local**, and **remote** sources are swappable.
- Use **Injectable** to generate GetIt registrations instead of manually wiring services.
- Use Flutter's **official `gen_l10n`** workflow with ARB files for localization.
- Use **Dio** as the standard network client, even when the current backend is a mocked local JSON source.
- Keep UI widgets focused on rendering and user intent; business rules and state transitions live outside widgets.

## 3. Recommended Folder Structure

```text
lib/
  app/
    app.dart
    routes/
      app_router.dart
      app_routes.dart
      app_pages.dart
      route_guards.dart
  core/
    di/
    errors/
    localization/
    network/
    theme/
  features/
    portfolio/
      domain/
        entities/
        repositories/
      data/
        datasources/
        models/
        repositories/
      presentation/
        cubit/
        pages/
        widgets/
```

```text
test/
  bdd/
    portfolio/
      view_portfolio_summary_bdd_test.dart
  unit/
    features/
      portfolio/
        presentation/
        domain/
  widget/
    features/
      portfolio/
```

Notes:

- `core/` holds cross-feature concerns only.
- Each feature owns its presentation logic and data boundaries.
- Route composition and page registration live centrally in `app/routes/`.
- Dependency registration lives in `core/di/` and is generated through Injectable.
- Localization source files live in `lib/l10n/*.arb`, with generated output consumed through shared extensions/helpers.

## 4. Navigation Architecture

### Standard

- Use **GoRouter** as the project navigation standard.
- Do not navigate with raw string literals from widgets.
- Centralize route construction and redirection rules in routing modules, not inside UI components.
- Keep all route/page registration in `app/routes/` so navigation stays discoverable from one place.

### Routing Rules

- Keep an `app_router.dart` entry point that composes the central app page list.
- Keep route metadata and page registration in `app/routes/` so navigation decisions live in one place.
- Widgets trigger navigation through **typed route helpers** or dedicated navigation actions, not by building route strings inline.
- Page widgets must not own redirect logic, deep-link parsing, or auth decision trees.

### Future-Ready Requirements

- **Deep linking:** route paths and parameters must remain stable and descriptive.
- **Route guards:** define guard points now so auth, onboarding, and subscription checks can be added later without rewriting page widgets.
- **Typed navigation:** prefer strongly typed route data or wrapper APIs over ad hoc `context.go('/path')` strings.

### GoRouter Example

```dart
final rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoute.dashboard.location,
  routes: appPages,
  redirect: appRouteGuard,
);
```

```dart
enum AppRoute {
  dashboard('/portfolio'),
  holdings('/portfolio/holdings'),
  transactions('/portfolio/transactions');

  const AppRoute(this.location);
  final String location;
}
```

```dart
void openHoldings(BuildContext context) {
  context.go(AppRoute.holdings.location);
}
```

### Navigation Best Practices

- Keep route names, paths, and parameter parsing close to the feature that owns them.
- Prefer a small number of stable top-level shells and nested feature routes.
- Pass only minimal navigation data; fetch heavy state through Cubits/use cases after navigation.
- Keep deep-link parsing deterministic and side-effect free.
- Never bury navigation rules inside reusable widgets.

## 5. State Management Rules

- Cubits own view state, loading flags, and presentation-safe derived values.
- Domain rules should live in use cases or domain services once the app grows beyond simple repository reads.
- UI should observe state and dispatch intent; it should not transform raw data into business rules on the fly.
- Avoid one Cubit coordinating unrelated features. Scale by feature boundary, not by screen size.

## 6. Localization and Networking Standards

- Define user-facing strings in **ARB files** and generate localization code via `flutter gen-l10n`.
- Keep localization helpers thin; generated strings are the source of truth.
- Use **Dio** for request/response handling, timeouts, interceptors, and future API evolution.
- Current MVP network responses may come from local JSON assets, but they must flow through the Dio-backed client layer rather than bypassing it.

## 7. Testing Strategy

### Testing Pyramid

- **Unit tests:** pure business logic, mappers, formatters, use cases, and Cubit state transitions.
- **Widget tests:** screen rendering, interaction flows, empty/loading/error states, and navigation triggers.
- **BDD tests:** critical business scenarios and user-facing workflows written for technical and non-technical readability, using `bdd_widget_test` for widget-level feature files where practical.

### When to Use BDD

Use BDD for:

- high-value portfolio workflows,
- business rules with product-facing language,
- acceptance-style state transitions,
- flows where product or design should be able to review expected behavior.

Do **not** use BDD for:

- trivial getters,
- low-level utility functions,
- layout-only checks,
- exhaustive permutation testing better handled by unit tests.

### BDD Conventions

- Use **Given-When-Then** naming and structure.
- Keep language business-readable.
- One scenario should express one behavior.
- Keep dependencies fake or in-memory so tests stay deterministic and fast.
- Prefer scenario-focused assertions over implementation details.

### BDD Example

```dart
test('''
Given an investor has holdings and cash balance
When the portfolio dashboard loads
Then the app shows the total portfolio value and top holdings
''', () async {
  // Given
  final repository = FakePortfolioRepository.withSampleData();
  final cubit = PortfolioCubit(repository: repository);

  // When
  await cubit.loadPortfolio();

  // Then
  expect(cubit.state.status, PortfolioStatus.success);
  expect(cubit.state.overview?.totalValue, greaterThan(0));
  expect(cubit.state.holdings, isNotEmpty);
});
```

### Standard Unit/Widget Test Guidance

- Use **unit tests** for fast coverage of edge cases and branching rules.
- Use **widget tests** for page composition, state-driven rendering, and user interactions.
- Prefer widget tests over integration tests for most MVP flows unless platform behavior must be proven.
- Keep fixtures deterministic and localized to the feature under test.

## 8. Error Handling Strategy

### State Layer

- Cubits must emit explicit loading, success, and failure states.
- Convert low-level exceptions into user-meaningful failures before they reach the UI.
- Avoid silent fallbacks that hide broken repository or parsing behavior.

### Navigation Layer

- Invalid route parameters should redirect to a safe fallback page or a dedicated error screen.
- Redirects must be deterministic and side-effect free.
- Route guards should return a navigation decision, not mutate feature state directly.

### UI Layer

- Show actionable error states with clear retry paths.
- Distinguish between empty state and error state.
- Do not expose raw exception text directly to end users.

## 9. Scalability Guidance

### Routing Scalability

- Compose routes by feature so new modules add route lists rather than editing one large file.
- Keep guard logic reusable and centralized.
- Use typed route helpers early to prevent string drift as route count grows.

### Testing Scalability

- Keep BDD coverage selective and valuable; do not convert the full test suite into prose.
- Use unit tests for breadth, widget tests for UI confidence, and BDD for shared understanding.
- Reuse fakes/builders instead of large fixture graphs.
- Favor fast local execution; slow tests quickly become ignored tests.

## 10. Practical MVP Boundaries

- Do not introduce auth-specific routing complexity until auth exists.
- Do not create use cases or abstractions with no current behavior behind them.
- Use future-ready route guards and modular structure, but keep implementation light.
- Add infrastructure only when a real feature needs it.

## 11. Documentation Rules

- Update this file when architecture, routing, or testing conventions change.
- Keep README high level; keep implementation rules here.
- Keep a separate example-driven architecture guide for onboarding and codebase walkthroughs.
- When adding a new feature, document:
  - its route ownership,
  - its Cubit/BLoC choice,
  - its repository boundary,
  - and its primary test strategy.
