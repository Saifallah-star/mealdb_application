class IngredientModel {
  final String name;
  final String Area;
  final String sCountry;
  final String? imageUrl;

  IngredientModel({
    required this.name,
    this.imageUrl,
    required this.Area,
    required this.sCountry,
  });

  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(
      name: json['strMeal'] ?? '',
      imageUrl: json['strMealThumb'] ?? '',
      Area: json['strArea'] ?? 'NoArea',
      sCountry: json['strCountry'] ?? 'NoCountry',
    );
  }
}
