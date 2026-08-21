class MealModel {
  final String? idMeal;
  final String name;
  final String category;
  final String Country;
  final String mealImage;
  MealModel({
    this.idMeal,
    required this.name,
    required this.category,
    required this.Country,
    required this.mealImage,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      idMeal: json['idMeal'] as String,
      name: json['strMeal'] as String,
      category: json['strCategory'] as String,
      Country: json['strCountry'] as String,
      mealImage: json['strMealThumb'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'idMeal': idMeal,
    'strMeal': name,
    'strMealThumb': mealImage,
    'strCategory': category,
    'strCountry': Country,
  };
}
