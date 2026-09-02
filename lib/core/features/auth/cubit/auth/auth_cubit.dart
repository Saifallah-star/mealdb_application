import 'package:mealdb_application/core/features/auth/cubit/auth/auth_states.dart';
import 'package:mealdb_application/core/features/auth/data/models/user_model.dart';
import 'package:mealdb_application/core/features/auth/data/repo/user_dao.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mealdb_application/core/utils/pref_helper.dart';

class AuthCubit extends Cubit<AuthStates> {
  final UserDao _userDao;

  AuthCubit(this._userDao) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await _userDao.getUserByEmail(email);
      if (user != null && user.password == password) {
        await PrefHelper.setLoggedIn(true);
        await PrefHelper.setUserId(user.id);
        emit(AuthSuccess(user));
      } else {
        emit(AuthFailure('Invalid email or password'));
        await PrefHelper.setLoggedIn(false);
        await PrefHelper.setUserId('');
      }
    } catch (e) {
      emit(AuthFailure('An error occurred: $e'));
      await PrefHelper.setLoggedIn(false);
      await PrefHelper.setUserId('');
    }
  }

  Future<bool> verifyPassword(String plainPassword) async {
    final userId = await PrefHelper.getUserId();
    if (userId == null || userId.isEmpty) return false;
    final user = await _userDao.getUserById(userId);
    return user?.password == plainPassword;
  }

  Future<void> logout() async {
    await PrefHelper.clear();
    emit(AuthUnauthenticated());
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
        await PrefHelper.setLoggedIn(true);
        await PrefHelper.setUserId(newUser.id);
        emit(AuthSuccess(newUser));
      } else {
        await PrefHelper.setLoggedIn(false);
        await PrefHelper.setUserId('');
        emit(AuthFailure('Failed to create user'));
      }
    } catch (e) {
      await PrefHelper.setLoggedIn(false);
      await PrefHelper.setUserId('');
      emit(AuthFailure('An error occurred: $e'));
    }
  }
}
