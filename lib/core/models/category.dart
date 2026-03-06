class Category {
  final String id;
  final String name;
  final String image;
  final String? description;
  final int? productsCount;

  Category({
    required this.id,
    required this.name,
    required this.image,
    this.description,
    this.productsCount,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      description: json['description'],
      productsCount: json['productsCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'description': description,
      'productsCount': productsCount,
    };
  }
}
