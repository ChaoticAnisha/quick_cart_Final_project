import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String categoryId;
  final String? categoryName;
  final String image;
  final double? rating;
  final int? reviews;
  final DateTime? createdAt;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.categoryId,
    this.categoryName,
    required this.image,
    this.rating,
    this.reviews,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    price,
    stock,
    categoryId,
    categoryName,
    image,
    rating,
    reviews,
    createdAt,
  ];

  bool get isInStock => stock > 0;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      categoryId: json['categoryId']?.toString() ?? '',
      categoryName: json['categoryName']?.toString(),
      image: json['image']?.toString() ?? '',
      rating: (json['rating'] as num?)?.toDouble(),
      reviews: (json['reviews'] as num?)?.toInt(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'price': price,
    'stock': stock,
    'categoryId': categoryId,
    if (categoryName != null) 'categoryName': categoryName,
    'image': image,
    if (rating != null) 'rating': rating,
    if (reviews != null) 'reviews': reviews,
    if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
  };
}
