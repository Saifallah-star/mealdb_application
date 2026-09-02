import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mealdb_application/core/constants/colors.dart';
import 'package:mealdb_application/core/features/auth/cubit/auth_cubit.dart';
import 'package:mealdb_application/core/features/auth/cubit/profile_cubit.dart';
import 'package:mealdb_application/core/features/auth/cubit/profile_states.dart';
import 'package:mealdb_application/core/features/auth/data/repo/user_dao.dart';
import 'package:mealdb_application/core/features/auth/data/services/image_picker_service.dart';
import 'package:mealdb_application/core/features/auth/views/login_page.dart';
import 'package:mealdb_application/core/utils/pref_helper.dart';

enum _AvatarAction { choose, remove }

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  late final ProfileCubit _profileCubit;

  @override
  void initState() {
    super.initState();
    _profileCubit = ProfileCubit(UserDao(), ImagePickerService());
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final userId = await PrefHelper.getUserId();
    await _profileCubit.loadProfile(userId);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _profileCubit.close();
    super.dispose();
  }

  Future<void> _showAvatarOptions(ProfileLoaded state) async {
    final action = await showModalBottomSheet<_AvatarAction>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              tileColor: Colors.transparent,
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose photo'),
              onTap: () => Navigator.pop(sheetContext, _AvatarAction.choose),
            ),
            if (state.user.profileImage != null)
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                tileColor: Colors.red,
                leading: const Icon(Icons.delete_outline, color: Colors.white),
                title: const Text(
                  'Remove photo',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () => Navigator.pop(sheetContext, _AvatarAction.remove),
              ),
          ],
        ),
      ),
    );
    if (!mounted || action == null) return;

    try {
      if (action == _AvatarAction.choose) {
        await _profileCubit.pickProfileImage();
      } else {
        await _profileCubit.removeProfileImage();
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to update profile photo: $error'),
          backgroundColor: AppColors.errorColor,
        ),
      );
    }
  }

  Future<void> _requestEditAccess() async {
    var enteredPassword = '';
    final password = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.backgroundColor,
        title: const Text(
          'Confirm your password',
          style: TextStyle(color: AppColors.SelectedColor),
        ),
        content: TextFormField(
          cursorColor: AppColors.SelectedColor,
          style: const TextStyle(color: AppColors.SelectedColor),
          obscureText: true,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Current password'),
          onChanged: (value) => enteredPassword = value,
          onFieldSubmitted: (value) => Navigator.pop(dialogContext, value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.SelectedColor),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
            ),
            onPressed: () => Navigator.pop(dialogContext, enteredPassword),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
    if (!mounted || password == null) return;
    final valid = await context.read<AuthCubit>().verifyPassword(password);
    if (!mounted) return;
    if (!valid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Wrong password'),
          backgroundColor: AppColors.errorColor,
        ),
      );
      return;
    }
    _profileCubit.enterEditMode();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final success = await _profileCubit.submitUserInfo(
      _nameController.text.trim(),
      _emailController.text.trim(),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        key: const Key('profile_update_snackbar'),
        content: Text(
          success
              ? 'Profile edited successfully.'
              : 'Unable to update profile.',
        ),
        backgroundColor: success
            ? AppColors.successColor
            : AppColors.errorColor,
      ),
    );
  }

  Future<void> _logout() async {
    // A SnackBar is a Hero during route transitions. Remove it before clearing
    // the navigation stack so it cannot collide with the incoming route.
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    await context.read<AuthCubit>().logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  InputDecoration _profileInputDecoration(String label, IconData icon) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        color: AppColors.primaryColor.withValues(alpha: .35),
      ),
    );
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.primaryColor),
      prefixIcon: Icon(icon, color: AppColors.primaryColor),
      filled: true,
      fillColor: Colors.white,
      disabledBorder: border,
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _profileCubit,
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded && !state.isEditing) {
            _nameController.text = state.user.name;
            _emailController.text = state.user.email;
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Scaffold(
              backgroundColor: AppColors.backgroundColor,
              body: Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              ),
            );
          }
          if (state is ProfileError) {
            return Scaffold(
              backgroundColor: AppColors.backgroundColor,
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(state.message, textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: _loadProfile,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: AppColors.backgroundColor,
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          final profile = state as ProfileLoaded;
          return Scaffold(
            backgroundColor: AppColors.secondaryColor,
            appBar: AppBar(
              foregroundColor: Colors.white,
              backgroundColor: AppColors.backgroundColor,
              elevation: 0,
            ),
            body: SafeArea(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.backgroundColor,
                      AppColors.secondaryColor,
                    ],
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Avatar === === ===
                        GestureDetector(
                          onTap: () => _showAvatarOptions(profile),
                          child: Stack(
                            children: [
                              _Avatar(path: profile.user.profileImage),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: AppColors.SelectedColor,
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 90),
                        // Name field === === ===
                        TextFormField(
                          controller: _nameController,
                          enabled: profile.isEditing && !profile.isSubmitting,
                          style: const TextStyle(
                            color: AppColors.SelectedColor,
                          ),
                          decoration: _profileInputDecoration(
                            'Name',
                            Icons.person_outline,
                          ),
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                              ? 'Name is required'
                              : null,
                        ),
                        const SizedBox(height: 30),
                        // Email field === === ===
                        TextFormField(
                          controller: _emailController,
                          enabled: profile.isEditing && !profile.isSubmitting,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(
                            color: AppColors.SelectedColor,
                          ),
                          decoration: _profileInputDecoration(
                            'Email',
                            Icons.email_outlined,
                          ),
                          validator: (value) {
                            final email = value?.trim() ?? '';
                            if (email.isEmpty) return 'Email is required';
                            if (!RegExp(
                              r'^[^@]+@[^@]+\.[^@]+$',
                            ).hasMatch(email)) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 50),
                        // Edit / Submit button === === === === === === === === ===
                        SizedBox(
                          width: double.infinity,
                          child: profile.isEditing
                              // Submit button === === ===
                              ? FilledButton(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                  ),
                                  onPressed: profile.isSubmitting
                                      ? null
                                      : _submit,
                                  child: profile.isSubmitting
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text(
                                          'Submit',
                                          style: TextStyle(
                                            color: AppColors.backgroundColor,
                                          ),
                                        ),
                                )
                              // Edit Profile button === === ===
                              : OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                    side: const BorderSide(
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                  onPressed: _requestEditAccess,
                                  child: const Text(
                                    'Edit Profile',
                                    style: TextStyle(
                                      color: AppColors.backgroundColor,
                                    ),
                                  ),
                                ),
                        ),
                        const SizedBox(height: 12),
                        // Logout button === === ===
                        SizedBox(
                          width: double.infinity,
                          child: TextButton.icon(
                            onPressed: _logout,
                            icon: const Icon(
                              Icons.logout,
                              color: AppColors.SelectedColor,
                            ),
                            label: const Text(
                              'Logout',
                              style: TextStyle(color: AppColors.SelectedColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({this.path});

  final String? path;

  @override
  Widget build(BuildContext context) {
    final hasImage = path != null && File(path!).existsSync();
    return CircleAvatar(
      radius: 58,
      backgroundColor: AppColors.primaryColor,
      backgroundImage: hasImage ? FileImage(File(path!)) : null,
      child: hasImage
          ? null
          : const Icon(Icons.person, size: 58, color: Colors.white),
    );
  }
}
