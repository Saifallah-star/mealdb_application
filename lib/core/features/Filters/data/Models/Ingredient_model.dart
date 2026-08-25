class IngredientModel {
  final String name;
  final String Area;
  final String sCountry;

  IngredientModel({
    required this.name,
    required this.Area,
    required this.sCountry,
  });

  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(
      name: json['strMeal'] ?? '',
      Area: json['strArea'] ?? 'NoArea',
      sCountry: json['strCountry'] ?? 'NoCountry',
    );
  }
}
