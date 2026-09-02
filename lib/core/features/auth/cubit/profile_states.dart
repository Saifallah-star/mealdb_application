import 'package:mealdb_application/core/features/auth/data/models/user_model.dart';

sealed class ProfileState {
  const ProfileState();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  const ProfileLoaded({
    required this.user,
    this.isEditing = false,
    this.isSubmitting = false,
  });

  final UserModel user;
  final bool isEditing;
  final bool isSubmitting;

  ProfileLoaded copyWith({
    UserModel? user,
    bool? isEditing,
    bool? isSubmitting,
  }) {
    return ProfileLoaded(
      user: user ?? this.user,
      isEditing: isEditing ?? this.isEditing,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

class ProfileError extends ProfileState {
  const ProfileError(this.message);

  final String message;
}
