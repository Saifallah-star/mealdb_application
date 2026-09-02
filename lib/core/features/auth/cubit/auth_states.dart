import 'package:mealdb_application/core/features/auth/data/models/user_model.dart';

sealed class AuthStates {
  const AuthStates();
}

class AuthInitial extends AuthStates {}

class AuthLoading extends AuthStates {}

class AuthSuccess extends AuthStates {
  final UserModel user;
  AuthSuccess(this.user);
}

class AuthFailure extends AuthStates {
  final String message;
  AuthFailure(this.message);
}

class AuthUnauthenticated extends AuthStates {}
