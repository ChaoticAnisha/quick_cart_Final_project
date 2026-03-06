import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.stock,
    required super.categoryId,
    super.categoryName,
    required super.image,
    super.rating,
    super.reviews,
    super.createdAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Handle category - can be String ID or Object
    String categoryId = '';
    String? categoryName;

    if (json['category'] != null) {
      if (json['category'] is String) {
        categoryId = json['category'] as String;
      } else if (json['category'] is Map) {
        categoryId =
            json['category']['_id']?.toString() ??
            json['category']['id']?.toString() ??
            '';
        categoryName = json['category']['name'] as String?;
      }
    }

    return ProductModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : (json['price'] as num?)?.toDouble() ?? 0.0,
      stock: json['stock'] as int? ?? 0,
      categoryId: categoryId,
      categoryName: categoryName,
      image: json['image'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble(),
      reviews: json['reviews'] as int?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      // Preserve categoryName for offline cache round-trips
      'category': categoryName != null
          ? {'_id': categoryId, 'name': categoryName}
          : categoryId,
      'image': image,
      if (rating != null) 'rating': rating,
      if (reviews != null) 'reviews': reviews,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }

  Product toEntity() {
    return Product(
      id: id,
      name: name,
      description: description,
      price: price,
      stock: stock,
      categoryId: categoryId,
      categoryName: categoryName,
      image: image,
      rating: rating,
      reviews: reviews,
      createdAt: createdAt,
    );
  }
}
