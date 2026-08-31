import 'package:mealdb_application/core/features/auth/cubit/auth_states.dart';
import 'package:mealdb_application/core/features/auth/data/models/user_model.dart';
import 'package:mealdb_application/core/features/auth/data/repo/user_dao.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthStates> {
  final UserDao _userDao;

  AuthCubit(this._userDao) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await _userDao.getUserByEmail(email);
      if (user != null && user.password == password) {
        emit(AuthSuccess(user));
      } else {
        emit(AuthFailure('Invalid email or password'));
      }
    } catch (e) {
      emit(AuthFailure('An error occurred: $e'));
    }
  }

  // ignore: non_constant_identifier_names
  Future<void> SignUp(String name, String email, String password) async {
    emit(AuthLoading());
    try {
      final newUser = await _userDao.insertUser(
        UserModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: name,
          email: email,
          password: password,
        ),
      );
      if (newUser != null) {
        emit(AuthSuccess(newUser));
      } else {
        emit(AuthFailure('Failed to create user'));
      }
    } catch (e) {
      emit(AuthFailure('An error occurred: $e'));
    }
  }
}
