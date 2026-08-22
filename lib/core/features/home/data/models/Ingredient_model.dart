class IngredientModel {
  final String idIngredient;
  final String name;
  final String? type;
  final String? ingredientImage;
  IngredientModel({
    required this.idIngredient,
    required this.name,
    this.ingredientImage,
    this.type = 'ingredient',
  });

  //* idIngredient (ok)
  //* strIngredient (ok)
  //! strThumb (not ok)  (ingredientImage)
  //! strType  (already null from API)

  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    if (json['strDescription'] == null) {
      json['strDescription'] = 'No description available';
      //json['strType'] = 'ingredient';
    }
    if (json['strThumb'] == null) {
      json['strThumb'] =
          'https://www.themealdb.com/images/ingredients/chicken.png';
    }
    return IngredientModel(
      idIngredient: json['idIngredient'],
      name: json['strIngredient'],
      // ingredientImage: json['strThumb'],
      type: json['strType'],
    );
  }

  Map<String, dynamic> toJson() => {
    'idIngredient': idIngredient,
    'strIngredient': name,
    //'strThumb': ingredientImage,
    'strType': type,
  };
}
