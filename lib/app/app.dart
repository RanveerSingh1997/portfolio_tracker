import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_tracker/app/routes/app_router.dart';
import 'package:portfolio_tracker/core/di/service_locator.dart';
import 'package:portfolio_tracker/core/errors/app_error_handler.dart';
import 'package:portfolio_tracker/core/localization/l10n_extensions.dart';
import 'package:portfolio_tracker/core/theme/app_theme.dart';
import 'package:portfolio_tracker/features/portfolio/domain/repositories/portfolio_repository.dart';
import 'package:portfolio_tracker/features/portfolio/presentation/cubit/portfolio_cubit.dart';
import 'package:portfolio_tracker/l10n/generated/app_localizations.dart';

/// Root application widget.
///
/// In production, dependencies are resolved from GetIt:
///
/// ```dart
/// await setupServiceLocator();
/// runApp(const PortfolioApp());
/// ```
///
/// In tests, the same entry point can be reused with explicit overrides:
///
/// ```dart
/// PortfolioApp(
///   repository: fakeRepository,
///   errorHandler: AppErrorHandler(),
///   router: createAppRouter(errorHandler: AppErrorHandler()),
/// )
/// ```
class PortfolioApp extends StatelessWidget {
  const PortfolioApp({
    super.key,
    this.initialLocation,
    this.repository,
    this.router,
    this.errorHandler,
  });

  final String? initialLocation;
  final PortfolioRepository? repository;
  final GoRouter? router;
  final AppErrorHandler? errorHandler;

  @override
  Widget build(BuildContext context) {
    // Allow tests or previews to inject their own dependencies, while the
    // normal app path continues to resolve everything from the service locator.
    final resolvedRepository = repository ?? getIt<PortfolioRepository>();
    final resolvedErrorHandler = errorHandler ?? getIt<AppErrorHandler>();
    final resolvedRouter =
        router ??
        (initialLocation == null
            ? getIt<GoRouter>()
            : createAppRouter(
                initialLocation: initialLocation,
                errorHandler: resolvedErrorHandler,
              ));

    // RepositoryProvider makes the feature repository available to anything
    // below this point in the widget tree.
    return RepositoryProvider<PortfolioRepository>.value(
      value: resolvedRepository,
      child: BlocProvider(
        // The Cubit is created once for the app shell and immediately loads the
        // portfolio so the first screen can render real state.
        create: (context) => PortfolioCubit(
          repository: context.read<PortfolioRepository>(),
          errorHandler: resolvedErrorHandler,
        )..loadPortfolio(),
        child: MaterialApp.router(
          // MaterialApp.router is the top-level Flutter app container. It owns
          // navigation, theme, localization, and other app-wide configuration.
          debugShowCheckedModeBanner: false,
          onGenerateTitle: (context) => context.l10n.appTitle,
          theme: AppTheme.lightTheme,
          routerConfig: resolvedRouter,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        ),
      ),
    );
  }
}
