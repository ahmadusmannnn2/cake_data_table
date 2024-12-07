class Dessert {
  Dessert(
    this.name, // The name of the dessert
    this.calories, // The number of calories in the dessert
    this.fat, // The amount of fat in the dessert (in grams)
    this.carbs, // The number of carbohydrates in the dessert (in grams)
    this.protein, // The amount of protein in the dessert (in grams)
    this.sodium, // The amount of sodium in the dessert (in milligrams)
    this.calcium, // The amount of calcium in the dessert (in milligrams)
    this.iron, // The amount of iron in the dessert (in milligrams)
  );

  final String name; // The name of the dessert (immutable)
  final int calories; // The number of calories in the dessert (immutable)
  final double fat; // The amount of fat in the dessert (in grams) (immutable)
  final int
      carbs; // The number of carbohydrates in the dessert (in grams) (immutable)
  final double
      protein; // The amount of protein in the dessert (in grams) (immutable)
  final int
      sodium; // The amount of sodium in the dessert (in milligrams) (immutable)
  final int
      calcium; // The amount of calcium in the dessert (in milligrams) (immutable)
  final int
      iron; // The amount of iron in the dessert (in milligrams) (immutable)
  bool selected =
      false; // Whether the dessert is currently selected (default is false)
}
