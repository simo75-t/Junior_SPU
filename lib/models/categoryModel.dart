class CategoryModel {
  final int id;
  final String name;
  final String type; // 'income' or 'expense'
  // Add any other fields if needed

  CategoryModel({required this.id, required this.name, required this.type});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
    );
  }
}
