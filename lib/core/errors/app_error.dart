import 'package:equatable/equatable.dart';

enum AppErrorType {
  unknown,
  portfolioLoad,
  routeNotFound,
  networkTimeout,
  networkConnection,
  httpError,
  parseError,
}

class AppError extends Equatable {
  const AppError({required this.type, this.details, this.statusCode});

  final AppErrorType type;
  final String? details;
  final int? statusCode;

  @override
  List<Object?> get props => [type, details, statusCode];
}
