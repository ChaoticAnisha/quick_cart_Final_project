import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/category.dart';

enum SortOption { none, priceAsc, priceDesc, nameAsc, ratingDesc }

class ProductState extends Equatable {
  final List<Product> products;
  final List<Product> allProducts;
  final List<Category> categories;
  final String? selectedCategoryId;
  final bool isLoading;
  final bool isCategoriesLoading;
  final String? errorMessage;
  final SortOption sortOption;

  const ProductState({
    this.products = const [],
    this.allProducts = const [],
    this.categories = const [],
    this.selectedCategoryId,
    this.isLoading = false,
    this.isCategoriesLoading = false,
    this.errorMessage,
    this.sortOption = SortOption.none,
  });

  ProductState copyWith({
    List<Product>? products,
    List<Product>? allProducts,
    List<Category>? categories,
    String? selectedCategoryId,
    bool? isLoading,
    bool? isCategoriesLoading,
    String? errorMessage,
    SortOption? sortOption,
    bool clearCategory = false,
    bool clearError = false,
  }) {
    return ProductState(
      products: products ?? this.products,
      allProducts: allProducts ?? this.allProducts,
      categories: categories ?? this.categories,
      selectedCategoryId:
          clearCategory ? null : (selectedCategoryId ?? this.selectedCategoryId),
      isLoading: isLoading ?? this.isLoading,
      isCategoriesLoading: isCategoriesLoading ?? this.isCategoriesLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      sortOption: sortOption ?? this.sortOption,
    );
  }

  @override
  List<Object?> get props => [
    products,
    allProducts,
    categories,
    selectedCategoryId,
    isLoading,
    isCategoriesLoading,
    errorMessage,
    sortOption,
  ];
}
