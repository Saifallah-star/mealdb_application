class CategoryModel {
  final String name;
  final String imageUrl;
  final String? Area;
  final String? Country;

  CategoryModel({
    required this.name,
    required this.imageUrl,
    this.Area,
    this.Country,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      name: json['strMeal'] ?? '',
      imageUrl: json['strMealThumb'] ?? '',
      Area: json['strArea'] ?? '',
      Country: json['strCountry'] ?? '',
    );
  }
}
