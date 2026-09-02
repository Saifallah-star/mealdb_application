import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mealdb_application/core/features/auth/cubit/profile_states.dart';
import 'package:mealdb_application/core/features/auth/data/models/user_model.dart';
import 'package:mealdb_application/core/features/auth/data/repo/user_dao.dart';
import 'package:mealdb_application/core/features/auth/data/services/image_picker_service.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._userDao, this._imagePickerService)
    : super(const ProfileLoading());

  final UserDao _userDao;
  final ImagePickerService _imagePickerService;

  Future<void> loadProfile(String? userId) async {
    emit(const ProfileLoading());
    if (userId == null || userId.isEmpty) {
      emit(const ProfileError('No signed-in user was found.'));
      return;
    }

    try {
      final user = await _userDao.getUserById(userId);
      if (user == null) {
        emit(const ProfileError('Your profile could not be found.'));
        return;
      }
      emit(ProfileLoaded(user: user));
    } catch (_) {
      emit(const ProfileError('Unable to load your profile.'));
    }
  }

  void enterEditMode() {
    final current = state;
    if (current is ProfileLoaded) emit(current.copyWith(isEditing: true));
  }

  Future<bool> pickProfileImage() async {
    final current = state;
    if (current is! ProfileLoaded) return false;
    try {
      final image = await _imagePickerService.pickAvatar();
      if (image == null) return false;
      await _userDao.updateProfileImage(current.user.id, image.path);
      emit(current.copyWith(user: _withProfileImage(current.user, image.path)));
      return true;
    } catch (_) {
      rethrow;
    }
  }

  Future<bool> removeProfileImage() async {
    final current = state;
    if (current is! ProfileLoaded) return false;
    try {
      await _userDao.updateProfileImage(current.user.id, null);
      emit(current.copyWith(user: _withProfileImage(current.user, null)));
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> submitUserInfo(String name, String email) async {
    final current = state;
    if (current is! ProfileLoaded) return false;
    emit(current.copyWith(isSubmitting: true));
    try {
      await _userDao.updateUserInfo(current.user.id, name, email);
      emit(
        current.copyWith(
          user: UserModel(
            id: current.user.id,
            name: name,
            email: email,
            password: current.user.password,
            profileImage: current.user.profileImage,
          ),
          isEditing: false,
          isSubmitting: false,
        ),
      );
      return true;
    } catch (_) {
      emit(current.copyWith(isSubmitting: false));
      return false;
    }
  }

  UserModel _withProfileImage(UserModel user, String? profileImage) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      password: user.password,
      profileImage: profileImage,
    );
  }
}
