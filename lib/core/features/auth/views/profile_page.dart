import 'package:flutter/material.dart';
import 'package:mealdb_application/core/constants/colors.dart';
import 'package:mealdb_application/core/features/auth/data/models/user_model.dart';
import 'package:mealdb_application/core/features/auth/data/repo/user_dao.dart';
import 'package:mealdb_application/core/features/auth/views/login_page.dart';

class ProfilePage extends StatelessWidget {
  String id;
  ProfilePage({super.key, required this.id});
  UserModel? user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.primaryColor,
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: AppColors.SelectedColor,
                ),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  user = await UserDao().getUserById(id);
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.SelectedColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 9, horizontal: 16),
                  child: Text('logout', style: TextStyle(fontSize: 16)),
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  user?.name ?? 'User',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('Email', style: TextStyle(fontSize: 16)),
              ),
              SizedBox(height: 16),
              Text('Profile Page', style: TextStyle(fontSize: 24)),
            ],
          ),
        ),
      ),
    );
  }
}
