class MealModel {
  final String? id;
  final String? name;
  final String? imageUrl;
  final String? Area;
  final String? Country;
  final String? Instructions;
  final String? YoutubeLink;
  List<String>? Ingredients;
  List<String>? Measures;

  MealModel({
    this.id,
    this.name,
    this.imageUrl,
    this.Area,
    this.Country,
    this.Instructions,
    this.YoutubeLink,
    this.Ingredients,
    this.Measures,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) {
    List<String> ingredients = [];
    List<String> measures = [];

    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];

      if (ingredient != null && ingredient.isNotEmpty) {
        ingredients.add(ingredient);
        measures.add(measure ?? '');
      }
    }

    return MealModel(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      imageUrl: json['strMealThumb'] ?? '',
      Area: json['strArea'] ?? 'N/A',
      Country: json['strCountry'] ?? 'N/A',
      Instructions: json['strInstructions'] ?? 'No Instructions',
      YoutubeLink: json['strYoutube'] ?? '',
      Ingredients: ingredients,
      Measures: measures,
    );
  }
}
