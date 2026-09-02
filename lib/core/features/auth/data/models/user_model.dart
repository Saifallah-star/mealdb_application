import 'package:mealdb_application/core/Database/database_constants.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final String? profileImage;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.profileImage,
  });

  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
      id: json[DBConstants.idColumn] as String,
      name: json[DBConstants.nameColumn] as String,
      email: json[DBConstants.emailColumn] as String,
      password: json[DBConstants.passwordColumn] as String,
      profileImage: json[DBConstants.columnProfileImage] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      DBConstants.idColumn: id,
      DBConstants.nameColumn: name,
      DBConstants.emailColumn: email,
      DBConstants.passwordColumn: password,
      DBConstants.columnProfileImage: profileImage,
    };
  }
}
