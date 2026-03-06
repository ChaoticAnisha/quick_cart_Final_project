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
}
