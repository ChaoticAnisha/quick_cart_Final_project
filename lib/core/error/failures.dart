import 'package:equatable/equatable.dart';

// Base Failure class
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

// API Failure
class ApiFailure extends Failure {
  final int? statusCode;

  const ApiFailure({required String message, this.statusCode}) : super(message);

  @override
  List<Object?> get props => [message, statusCode];
}

// Local Database Failure
class LocalDatabaseFailure extends Failure {
  const LocalDatabaseFailure({
    String message = 'Local database operation failed',
  }) : super(message);
}

// Network Failure
class NetworkFailure extends Failure {
  const NetworkFailure({String message = 'Network connection error'})
    : super(message);
}
