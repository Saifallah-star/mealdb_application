abstract class DBConstants {
  static final String databaseName = 'mealdb.db';
  static final int databaseVersion = 4;

  // users table === ===
  static final String usersTable = 'Users';
  static final String idColumn = 'id';
  static final String nameColumn = 'name';
  static final String emailColumn = 'email';
  static final String passwordColumn = 'password';
  static final String columnProfileImage = 'profile_image';

  //favorite meals table === ===
  static final String mealsTable = 'Meals';
  static final String mealIdColumn = 'id';
  static final String mealNameColumn = 'name';
  static final String mealImageColumn = 'image';
  static final String mealAreaColumn = 'area';
  static final String mealCountryColumn = 'country';
  // Foreign key to the Users table
  static final String userIdColumn = 'user_id';
}
